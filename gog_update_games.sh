#!/bin/bash
#
# Mirror every GOG base game and DLC installer, plus extras, for every platform.
# Patches and separate language packs are intentionally excluded.

set -o pipefail

BASE_DIR="${1:-/media/lea/games/gog}"
LOG_FILE="$BASE_DIR/update.log"

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
    --retries 5
    --threads 2
)

echo "------------------------------------------------------------"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting GOG mirror"
echo "Directory: $BASE_DIR"
echo "Content: base-game and DLC installers plus extras; all platforms; no patches"
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

# Update the local GOG database first
echo "[*] Updating local GOG database..."
if ! lgogdownloader --update-cache --include-hidden-products; then
    echo "[!] Cache update failed. Aborting."
    exit 1
fi

# Remove files that are no longer present in the selected GOG catalog.
echo "[*] Cleaning orphaned/obsolete files..."
if ! lgogdownloader "${COMMON_ARGS[@]}" --check-orphans --delete-orphans; then
    echo "[!] Orphan cleanup failed. Aborting before download."
    exit 1
fi
echo "[+] Cleanup completed."

# Download every matching game; no --game filter means the entire account.
echo "[*] Syncing the GOG mirror..."
if ! lgogdownloader "${COMMON_ARGS[@]}" --download; then
    echo "[!] Download/sync failed. See $LOG_FILE for details."
    exit 1
fi

# Successful repairs can leave superseded files with an .old suffix.
echo "[*] Removing leftover .old files..."
find "$BASE_DIR" -type f -name "*.old" -print -delete

echo "------------------------------------------------------------"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Mirror completed."
echo "------------------------------------------------------------"
