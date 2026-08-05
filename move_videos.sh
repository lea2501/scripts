#!/bin/sh

# POSIX-compliant script to move video files while translating image-oriented
# directory names to their video-oriented equivalents.

# Defaults
SOURCE_DIR=""
DEST_DIR=""
DRY_RUN=false

# Video extensions (case insensitive matching)
VIDEO_EXTS="mp4 mov avi mkv flv wmv m4v 3gp webm"

# Help function
show_help() {
    echo "Usage: $0 [options] source_directory destination_directory"
    echo
    echo "Options:"
    echo "  -n, --dry-run    Show what would be moved without actually doing it"
    echo "  -h, --help       Show this help message"
    echo
    echo "Example:"
    echo "  $0 ~/Pictures ~/videos"
    echo "  $0 -n ~/PhoneDCIM ~/backup/videos"
    echo
    echo "Directory names are translated automatically:"
    echo "  fotos/photos -> videos"
    echo "  pics         -> vids"
    echo "For example: trh-fotos/trh-fotos-202607 becomes"
    echo "             trh-videos/trh-videos-202607"
}

# Translate complete hyphen-delimited words in directory components. Applying
# this only to the relative directory keeps video filenames unchanged.
translate_directory_path() {
    printf '%s\n' "$1" |
        sed -E \
            -e 's#(^|/|-)(fotos|photos)(/|-|$)#\1videos\3#g' \
            -e 's#(^|/|-)pics(/|-|$)#\1vids\2#g'
}

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "Error: Unknown option $1" >&2
            show_help
            exit 1
            ;;
        *)
            if [ -z "$SOURCE_DIR" ]; then
                SOURCE_DIR="$1"
            elif [ -z "$DEST_DIR" ]; then
                DEST_DIR="$1"
            else
                echo "Error: Too many arguments" >&2
                show_help
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate parameters
if [ -z "$SOURCE_DIR" ] || [ -z "$DEST_DIR" ]; then
    echo "Error: Source and destination directories are required" >&2
    show_help
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist: $SOURCE_DIR" >&2
    exit 1
fi

# Create destination directory if it doesn't exist
if [ "$DRY_RUN" = false ]; then
    mkdir -p "$DEST_DIR"
fi

echo "Source directory: $SOURCE_DIR"
echo "Destination directory: $DEST_DIR"
echo "Mode: $([ "$DRY_RUN" = true ] && echo "Dry run (simulation)" || echo "Real execution")"
echo

# Build find command for case insensitive matching
find "$SOURCE_DIR" -type f | while IFS= read -r file; do
    # Check if file has a video extension (case insensitive)
    ext=$(echo "$file" | tr '[:upper:]' '[:lower:]' | awk -F. '{print $NF}')
    found=false
    
    for video_ext in $VIDEO_EXTS; do
        if [ "$ext" = "$video_ext" ]; then
            found=true
            break
        fi
    done
    
    [ "$found" = false ] && continue

    # Get relative path
    relative_path="${file#$SOURCE_DIR/}"
    
    # Translate only the directory portion of the relative path. File names
    # remain exactly as they were in the source.
    relative_dir=$(dirname "$relative_path")
    file_name=$(basename "$relative_path")

    if [ "$relative_dir" = "." ]; then
        dest_dir="$DEST_DIR"
    else
        translated_dir=$(translate_directory_path "$relative_dir")
        dest_dir="$DEST_DIR/$translated_dir"
    fi
    dest_file="$dest_dir/$file_name"
    
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would move: $file"
        echo "          to: $dest_file"
    else
        # Create destination directory if needed
        mkdir -p "$dest_dir"
        
        # Never overwrite an existing destination. This matters when old
        # directory layouts have already been merged or renamed manually.
        if [ -e "$dest_file" ]; then
            if cmp -s "$file" "$dest_file"; then
                if rm "$file"; then
                    echo "Removed source copy already stored at destination: $file"
                else
                    echo "Error removing identical source copy: $file" >&2
                fi
            else
                echo "Error: destination already exists with different content: $dest_file" >&2
            fi
            continue
        fi

        # Move the file
        if mv -v "$file" "$dest_file"; then
            echo "Moved: $file -> $dest_file"
        else
            echo "Error moving: $file" >&2
        fi
    fi
done

echo
echo "Operation completed."
if [ "$DRY_RUN" = true ]; then
    echo "NOTE: This was a dry run - no files were actually moved"
fi
