#!/bin/bash
#
# Mirror every GOG base game and DLC installer, plus extras, for every platform.
# Patches and separate language packs are intentionally excluded. Recently
# updated games are prioritized between bounded backlog download windows.

set -o pipefail

BASE_DIR="${1:-/media/lea/games/gog}"
LOG_FILE="$BASE_DIR/update.log"
GOG_THREADS="${GOG_THREADS:-2}"
GOG_BACKLOG_HOURS="${GOG_BACKLOG_HOURS:-12}"
GOG_RETRIES="${GOG_RETRIES:-5}"
PRIORITY_STATE_FILE="$BASE_DIR/.lgog-priority-initialized"

if [[ ! "$GOG_THREADS" =~ ^[1-9][0-9]*$ ]]; then
    echo "[!] GOG_THREADS must be a positive integer: $GOG_THREADS" >&2
    exit 1
fi

if [[ ! "$GOG_BACKLOG_HOURS" =~ ^[1-9][0-9]*$ ]]; then
    echo "[!] GOG_BACKLOG_HOURS must be a positive integer: $GOG_BACKLOG_HOURS" >&2
    exit 1
fi

if [[ ! "$GOG_RETRIES" =~ ^[0-9]+$ ]]; then
    echo "[!] GOG_RETRIES must be a non-negative integer: $GOG_RETRIES" >&2
    exit 1
fi

BACKLOG_DURATION="${GOG_BACKLOG_HOURS}h"

# Refuse to write into the mount point directory if the games volume is absent.
if ! mountpoint -q /media/lea/games; then
    echo "[!] /media/lea/games is not mounted. Aborting." >&2
    exit 1
fi

MOUNT_OPTIONS="$(findmnt -n -o OPTIONS -T "$BASE_DIR")"
case ",$MOUNT_OPTIONS," in
    *,ro,*)
        echo "[!] The volume containing $BASE_DIR is mounted read-only. Aborting." >&2
        exit 1
        ;;
esac

mkdir -p "$BASE_DIR"
if [ ! -w "$BASE_DIR" ]; then
    echo "[!] $BASE_DIR is not writable. Aborting." >&2
    exit 1
fi

# Log to both the terminal and the mirror directory.
exec > >(tee -a "$LOG_FILE") 2>&1

# Use arrays so every option is passed as a separate, safely quoted argument.
COMMON_ARGS=(
    --directory "$BASE_DIR"
    --platform all
    --include installers,extras
    --exclude patches
    --include-hidden-products
    --use-cache
    --retries "$GOG_RETRIES"
    --threads "$GOG_THREADS"
    --progress-interval 10000
    --no-window-progress
    --no-color
)

echo "------------------------------------------------------------"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting GOG mirror"
echo "Directory: $BASE_DIR"
echo "Content: base-game and DLC installers plus extras; all platforms; no patches"
echo "Download threads: $GOG_THREADS"
echo "Retries per file: $GOG_RETRIES"
echo "Backlog window: $BACKLOG_DURATION"
echo "------------------------------------------------------------"

# Check for active login session
echo "[*] Checking GOG login session..."
if ! lgogdownloader --check-login-status >/dev/null 2>&1; then
    echo "[-] No valid session found. Starting login..."
    if ! lgogdownloader --login; then
        echo "[!] Login failed. Aborting."
        exit 1
    fi
else
    echo "[+] Session is valid."
fi

# Existing accounts can have every title marked as "new", which would turn the
# priority phase into another multi-terabyte backlog. Establish a one-time
# baseline so only notifications created after this mirror run are prioritized.
if [ ! -f "$PRIORITY_STATE_FILE" ]; then
    echo "[*] Initializing new/updated notification baseline..."
    if ! lgogdownloader --update-cache --include-hidden-products; then
        echo "[!] Cache update failed while initializing priority flags."
        exit 1
    fi
    if ! lgogdownloader --clear-update-flags; then
        echo "[!] Could not initialize priority flags."
        exit 1
    fi
    printf 'Initialized: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" > "$PRIORITY_STATE_FILE"
    echo "[+] Priority baseline initialized. Existing titles remain in the full backlog."
fi

run_priority_download() {
    local filter="$1"
    local description="$2"
    local output_file
    local command_status

    output_file=$(mktemp "${TMPDIR:-/tmp}/gog-priority.XXXXXX") || return 1
    lgogdownloader "${COMMON_ARGS[@]}" "$filter" --download 2>&1 | tee "$output_file"
    command_status=${PIPESTATUS[0]}

    if ((command_status != 0)); then
        echo "[!] $description command failed with status $command_status."
        rm -f "$output_file"
        return 1
    fi

    # LGOGDownloader currently returns success even when individual downloads
    # exhaust their retries. Its reliable default-level marker is this warning.
    if grep -q 'Download complete (' "$output_file"; then
        echo "[!] $description left files incomplete after exhausting retries."
        rm -f "$output_file"
        return 1
    fi

    rm -f "$output_file"
    return 0
}

sync_priority_games() {
    local priority_complete=true

    # Refresh update flags and product metadata before each backlog window.
    echo "[*] Updating local GOG database..."
    if ! lgogdownloader --update-cache --include-hidden-products; then
        echo "[!] Cache update failed. Aborting."
        exit 1
    fi

    # Newly acquired games should not wait behind the historical backlog.
    echo "[*] Downloading newly added games first..."
    if ! run_priority_download --new "Priority new-game download"; then
        priority_complete=false
    fi

    # Bring recently changed games current before spending time on the backlog.
    echo "[*] Downloading recently updated games first..."
    if ! run_priority_download --updated "Priority update download"; then
        priority_complete=false
    fi

    # Delete obsolete installers only after their replacements downloaded. A
    # game may appear in both filters; the second pass is harmless in that case.
    if [ "$priority_complete" != true ]; then
        echo "[!] Priority downloads remain incomplete."
        echo "[*] Preserving notification flags and skipping priority orphan cleanup."
        return 1
    fi

    echo "[*] Cleaning obsolete files from newly added games..."
    if ! lgogdownloader "${COMMON_ARGS[@]}" --new --check-orphans --delete-orphans; then
        echo "[!] New-game orphan cleanup failed; notification flags were preserved."
        exit 1
    fi

    echo "[*] Cleaning obsolete files from updated games..."
    if ! lgogdownloader "${COMMON_ARGS[@]}" --updated --check-orphans --delete-orphans; then
        echo "[!] Priority orphan cleanup failed; update flags were preserved."
        exit 1
    fi

    if ! lgogdownloader --clear-update-flags; then
        echo "[!] Could not clear completed update flags. Aborting."
        exit 1
    fi
    echo "[+] New and recently updated games are current."
}

cycle=0
while true; do
    cycle=$((cycle + 1))
    echo "------------------------------------------------------------"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting priority cycle $cycle"

    if ! sync_priority_games; then
        echo "[*] Continuing with this backlog window; priority files will retry next cycle."
    fi

    # Work on the full historical backlog for a bounded period. GNU timeout
    # sends SIGINT so LGOGDownloader can leave resumable partial files.
    echo "[*] Syncing full backlog for up to $BACKLOG_DURATION..."
    backlog_output=$(mktemp "${TMPDIR:-/tmp}/gog-backlog.XXXXXX") || exit 1
    timeout --foreground --signal=INT --kill-after=2m \
        "$BACKLOG_DURATION" \
        lgogdownloader "${COMMON_ARGS[@]}" --download 2>&1 | tee "$backlog_output"
    backlog_status=${PIPESTATUS[0]}
    backlog_had_failures=false
    if grep -q 'Download complete (' "$backlog_output"; then
        backlog_had_failures=true
    fi
    rm -f "$backlog_output"

    case "$backlog_status" in
        0)
            if [ "$backlog_had_failures" = true ]; then
                echo "[!] Backlog pass exhausted retries for one or more files."
                echo "[*] Starting another priority cycle before retrying them."
            else
                echo "[+] Full backlog download completed without transfer failures."
                break
            fi
            ;;
        124)
            echo "[*] Backlog window ended; refreshing updates before resuming."
            ;;
        130)
            echo "[!] Interrupted by user. Partial downloads were kept for resuming."
            exit 130
            ;;
        *)
            echo "[!] Backlog download failed with status $backlog_status. See $LOG_FILE."
            exit "$backlog_status"
            ;;
    esac
done

# Close the at-most-12-hour gap created by the final backlog window.
echo "[*] Running final priority refresh..."
if ! sync_priority_games; then
    echo "[!] Final priority refresh remains incomplete; skipping global cleanup."
    exit 1
fi

# With the complete catalog downloaded, stale files can be removed safely.
echo "[*] Cleaning orphaned/obsolete files from the complete mirror..."
if ! lgogdownloader "${COMMON_ARGS[@]}" --check-orphans --delete-orphans; then
    echo "[!] Final orphan cleanup failed."
    exit 1
fi
echo "[+] Final cleanup completed."

# Successful repairs can leave superseded files with an .old suffix.
echo "[*] Removing leftover .old files..."
find "$BASE_DIR" -type f -name "*.old" -print -delete

echo "------------------------------------------------------------"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Mirror completed."
echo "------------------------------------------------------------"
