#!/bin/sh
#
# update-gog.sh
# Automatically update GOG game installers using lgogdownloader (v3+).
# Keeps only the latest versions, excluding patches.
# Logs all activity for later review.

# Check arguments
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/GOG"
    echo "Example: $0 /media/lea/games/gog/"
    exit 1
fi

BASE_DIR="$1"
LOG_FILE="$BASE_DIR/update.log"

# Common download parameters
ARGS="--download --retries 5 --threads 2 --use-cache --no-remote-xml --exclude patches"

# Timestamp for log entries
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# Create directory and files
mkdir -p "$BASE_DIR"

echo "------------------------------------------------------------"
echo "[$TIMESTAMP] Starting GOG update process"
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
if ! lgogdownloader --update-cache 2>&1; then
    echo "[!] Cache update failed."
fi

# Clean orphaned files (new flags replaces old --purge)
echo "[*] Cleaning orphaned/obsolete files..."
if ! lgogdownloader --directory "$BASE_DIR" --check-orphans --delete-orphans 2>&1; then
    echo "[-] Nothing to clean or cleanup failed."
else
    echo "[+] Cleanup completed."
fi

# Sync/download games
echo "[*] Syncing installers in: $BASE_DIR"
if ! lgogdownloader --directory "$BASE_DIR" $ARGS 2>&1; then
    echo "[!] Download/sync failed. See log for details."
    exit 1
fi

# Remove leftover .old files
echo "[*] Removing leftover .old files..."
find "$BASE_DIR" -type f -name "*.old" -print -delete 2>&1

echo "------------------------------------------------------------"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Update completed."
echo "------------------------------------------------------------"
