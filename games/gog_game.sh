#!/bin/bash
# List the cached GOG library and download one game (including its DLC/extras).

set -o pipefail

BASE_DIR="${GOG_DIR:-/media/lea/games/gog}"
CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/lgogdownloader/gamedetails.json"
GOG_THREADS="${GOG_THREADS:-4}"

usage() {
    cat <<'EOF'
Usage:
  gog_game.sh                   Refresh, hash-check and list outdated games
  gog_game.sh audit [text]      Same, optionally filtering by title/name
  gog_game.sh list [text]       Quick check; list only pending games
  gog_game.sh list-all [text]   Quick check; list every game
  gog_game.sh download GAME     Download one game by its GOG name
  gog_game.sh refresh           Refresh the local GOG catalog

The hash audit can take a long time because it reads every downloaded installer.

Environment:
  GOG_DIR=/path       Download directory (default: /media/lea/games/gog)
  GOG_THREADS=N       Parallel downloads (default: 4)
EOF
}

die() {
    echo "[!] $*" >&2
    exit 1
}

require_cache() {
    [ -r "$CACHE_FILE" ] || die "Catalog cache not found. Run: $0 refresh"
}

catalog() {
    local search="${1:-}"
    local show_all="${2:-false}"
    local status_file="${3:-}"
    require_cache
    python3 - "$CACHE_FILE" "$BASE_DIR" "$search" "$show_all" "$status_file" <<'PY'
import json
import os
import sys

cache_path, base_dir, needle, show_all, status_path = sys.argv[1:]
needle = needle.casefold()
show_all = show_all == "true"

with open(cache_path, encoding="utf-8") as stream:
    games = json.load(stream)["games"]

def selected_files(game):
    # The cache was generated with the configured language and contains every
    # selected platform. Match the full mirror: installers and extras, no patches.
    for item in game.get("installers", []):
        yield item, False, False
    for item in game.get("extras", []):
        yield item, False, True
    for dlc in game.get("dlcs", []):
        for item in dlc.get("installers", []):
            yield item, True, False
        for item in dlc.get("extras", []):
            yield item, True, True

def local_path(root_name, item, is_dlc):
    relative = item["path"].lstrip("/")
    if is_dlc:
        relative = os.path.join(root_name, "dlc", relative)
    return os.path.join(base_dir, relative)

def human_size(value):
    units = ("B", "KiB", "MiB", "GiB", "TiB")
    size = float(value)
    for unit in units:
        if size < 1024 or unit == units[-1]:
            return f"{size:.0f} {unit}" if unit == "B" else f"{size:.1f} {unit}"
        size /= 1024

status = {}
if status_path:
    with open(status_path, encoding="utf-8", errors="replace") as stream:
        for line in stream:
            fields = line.split()
            if len(fields) >= 3 and fields[0] in {"OK", "ND", "MD5", "FS"}:
                status[(fields[1], fields[2])] = fields[0]

rows = []
for game in games:
    title = game.get("title", game["gamename"])
    name = game["gamename"]
    if needle and needle not in title.casefold() and needle not in name.casefold():
        continue
    files = list(selected_files(game))
    pending = []
    for item, is_dlc, is_extra in files:
        expected = int(item.get("size", 0))
        path = local_path(name, item, is_dlc)
        if status_path:
            state = status.get((item.get("gamename", name), os.path.basename(path)), "ND")
            is_pending = state != "OK"
            if is_extra:
                try:
                    is_pending = os.path.getsize(path) < expected
                except OSError:
                    is_pending = True
        else:
            try:
                actual = os.path.getsize(path)
            except OSError:
                actual = -1
            # GOG reports these sizes rounded down to MiB, so a complete file is
            # commonly a little larger than the cached value.
            is_pending = actual < expected
        if is_pending:
            pending.append(expected)
    if show_all or pending:
        rows.append((title, name, len(pending), sum(pending), len(files)))

rows.sort(key=lambda row: row[0].casefold())
print(f"{'TITLE':48} {'GOG NAME':40} {'PENDING':>9} {'SIZE':>10}")
print(f"{'-' * 48} {'-' * 40} {'-' * 9} {'-' * 10}")
for title, name, count, size, total in rows:
    pending = f"{count}/{total}"
    print(f"{title[:48]:48} {name[:40]:40} {pending:>9} {human_size(size):>10}")
pending_files = sum(row[2] for row in rows)
pending_bytes = sum(row[3] for row in rows)
print(f"\n{len(rows)} game(s); {pending_files} pending file(s), {human_size(pending_bytes)} total.")
if status_path:
    print("PENDING means missing, incomplete or checksum mismatch.")
    print("GOG does not publish checksums for some extras; those use its available metadata.")
else:
    print("Quick check: PENDING means files missing or apparently incomplete (no hashes read).")
PY
}

audit() {
    local search="${1:-}"
    local status_file
    command -v lgogdownloader >/dev/null || die "lgogdownloader is not installed."
    echo "[*] Refreshing the GOG catalog before the audit..."
    refresh || die "Could not refresh the catalog."
    status_file=$(mktemp "${TMPDIR:-/tmp}/gog-status.XXXXXX") || exit 1
    echo "[*] Reading and hashing local installers. This can take a long time..."
    if ! lgogdownloader \
        --directory "$BASE_DIR" \
        --platform all \
        --include installers,extras \
        --exclude patches \
        --include-hidden-products \
        --use-cache \
        --no-fast-status-check \
        --no-color \
        --status >"$status_file"; then
        rm -f "$status_file"
        die "The checksum audit failed."
    fi
    catalog "$search" false "$status_file"
    rm -f "$status_file"
}

refresh() {
    command -v lgogdownloader >/dev/null || die "lgogdownloader is not installed."
    if ! lgogdownloader --check-login-status >/dev/null 2>&1; then
        echo "[*] GOG login is required."
        lgogdownloader --login || die "Login failed."
    fi
    lgogdownloader --update-cache --include-hidden-products
}

download_game() {
    local game="$1"
    [[ "$game" =~ ^[A-Za-z0-9_]+$ ]] || die "Invalid GOG name: $game"
    [[ "$GOG_THREADS" =~ ^[1-9][0-9]*$ ]] || die "GOG_THREADS must be a positive integer."
    require_cache
    jq -e --arg game "$game" '.games[] | select(.gamename == $game)' \
        "$CACHE_FILE" >/dev/null || die "Game not found: $game (use '$0 list TEXT')."

    mountpoint -q /media/lea/games || die "/media/lea/games is not mounted."
    local options
    options=$(findmnt -n -o OPTIONS -T "$BASE_DIR") || die "Cannot inspect $BASE_DIR mount."
    case ",$options," in
        *,ro,*) die "The games disk is read-only. Remount it read-write first." ;;
    esac
    mkdir -p "$BASE_DIR" || die "Cannot create $BASE_DIR."
    [ -w "$BASE_DIR" ] || die "$BASE_DIR is not writable."

    command -v lgogdownloader >/dev/null || die "lgogdownloader is not installed."
    if ! lgogdownloader --check-login-status >/dev/null 2>&1; then
        echo "[*] GOG login is required."
        lgogdownloader --login || die "Login failed."
    fi

    echo "[*] Downloading $game with $GOG_THREADS parallel transfers..."
    lgogdownloader \
        --directory "$BASE_DIR" \
        --platform all \
        --include installers,extras \
        --exclude patches \
        --include-hidden-products \
        --use-cache \
        --retries 5 \
        --threads "$GOG_THREADS" \
        --progress-interval 1000 \
        --game "^${game}$" \
        --download
}

case "${1:-}" in
    list)
        catalog "${2:-}" false
        ;;
    list-all)
        catalog "${2:-}" true
        ;;
    audit)
        audit "${2:-}"
        ;;
    refresh)
        refresh
        ;;
    download)
        [ -n "${2:-}" ] || die "Specify a GOG name. Use: $0 list TEXT"
        download_game "$2"
        ;;
    -h|--help|help)
        usage
        ;;
    "")
        audit
        ;;
    *)
        die "Unknown command: $1 (use --help)"
        ;;
esac
