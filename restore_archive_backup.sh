#!/bin/sh

# Default values
DRY_RUN=0
REMOTE_BACKUP=""  # Mandatory - your external backup location
LOCAL_SOURCE=""  # Default: current directory
RECOVERY_DIR="$HOME/archive-pictures"  # Where to restore missing files

show_help() {
    echo "Usage: $0 [OPTIONS] REMOTE_BACKUP [LOCAL_SOURCE] [RECOVERY_DIR]"
    echo "Recover files missing in LOCAL_SOURCE from REMOTE_BACKUP to RECOVERY_DIR"
    echo ""
    echo "Options:"
    echo "  -n      Dry run: show what would be copied"
    echo "  -h      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 -n /media/backup/photos ~/Photos ~/recovered-photos"
    echo "  $0 /media/backup/photos ~/Photos"
    echo "  $0 /media/backup/photos"
    exit 0
}

# Process options
while getopts "nh" opt; do
    case $opt in
        n) DRY_RUN=1;;
        h) show_help;;
        *) show_help;;
    esac
done

shift $((OPTIND-1))

# Assign positional parameters
[ $# -ge 1 ] && REMOTE_BACKUP="$1"
[ $# -ge 2 ] && LOCAL_SOURCE="$2"
[ $# -ge 3 ] && RECOVERY_DIR="$3"

# Validations
if [ -z "$REMOTE_BACKUP" ]; then
    echo "Error: You must specify the remote backup directory" >&2
    show_help
    exit 1
fi

if [ ! -d "$REMOTE_BACKUP" ]; then
    echo "Error: Remote backup directory doesn't exist: $REMOTE_BACKUP" >&2
    exit 1
fi

if [ ! -d "$LOCAL_SOURCE" ]; then
    echo "Error: Local source directory doesn't exist: $LOCAL_SOURCE" >&2
    exit 1
fi

# Display configuration
echo "Configuration:"
echo "  Remote Backup: $REMOTE_BACKUP"
echo "  Local Source:  $LOCAL_SOURCE"
echo "  Recovery Dir:  $RECOVERY_DIR"
[ $DRY_RUN -eq 1 ] && echo "  Mode:         Dry Run (-n enabled)"

# Find and recover missing files
find "$REMOTE_BACKUP" -type f | while read -r backup_file; do
    # Get relative path
    rel_path="${backup_file#$REMOTE_BACKUP/}"
    local_file="$LOCAL_SOURCE/$rel_path"
    recovery_file="$RECOVERY_DIR/$rel_path"
    
    # If file is missing in local source
    if [ ! -e "$local_file" ]; then
        if [ $DRY_RUN -eq 1 ]; then
            # Dry run: just show
            echo "[Dry Run] Would recover: $backup_file -> $recovery_file"
        else
            # Actual recovery: create parent dirs and copy
            mkdir -p "$(dirname "$recovery_file")"
            cp -v "$backup_file" "$recovery_file"
        fi
    fi
done

# Final summary
if [ $DRY_RUN -eq 1 ]; then
    echo "Dry run completed. No files were actually modified."
else
    echo "Recovery completed. Missing files copied to $RECOVERY_DIR"
fi
