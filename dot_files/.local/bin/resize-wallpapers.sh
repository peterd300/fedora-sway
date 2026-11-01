#!/bin/bash

# Ensure ImageMagick is installed
if ! command -v mogrify &> /dev/null || ! command -v identify &> /dev/null; then
    echo "Error: ImageMagick is required but not installed."
    echo "Install it using: sudo apt install imagemagick (Debian/Ubuntu) or brew install imagemagick (Mac)"
    exit 1
fi

# --- Configuration ---
MAX_WIDTH=1920
MAX_HEIGHT=1080
MAX_SIZE="${MAX_WIDTH}x${MAX_HEIGHT}>" 

show_help() {
    echo "Usage: $0 [-r] [-d] [-l] [path]"
    echo "Resizes PNG/JPG images to a max of ${MAX_WIDTH}x${MAX_HEIGHT} pixels in-place (ONLY if larger)."
    echo ""
    echo "Options:"
    echo "  -r    Search recursively through subdirectories."
    echo "  -d    Dry run: show what would be resized without modifying files."
    echo "  -l    Logging: write terminal output to 'resized_log-YYYYMMDD-HHMM.log'."
    echo "  -h    Show this help message."
    echo ""
    echo "If path is omitted, the current working directory will be used."
    exit 0
}

# Parse options
RECURSIVE=false
DRY_RUN=false
LOGGING=false
while getopts "rdlh" opt; do
    case "$opt" in
        r) RECURSIVE=true ;;
        d) DRY_RUN=true ;;
        l) LOGGING=true ;;
        h) show_help ;;
        *) show_help ;;
    esac
done
shift $((OPTIND-1))

# Set target directory (default to current directory if empty)
TARGET_DIR="${1:-.}"

# Verify the path exists and is a directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: '$TARGET_DIR' is not a valid directory."
    exit 1
fi

# Setup logging file if requested
if [ "$LOGGING" = true ]; then
    TIMESTAMP=$(date +"%Y%m%d-%H%M")
    LOG_FILE="resized_log-${TIMESTAMP}.log"
    > "$LOG_FILE" # Clear or create the log file empty
fi

# Helper function to print to terminal AND log file simultaneously
log_message() {
    echo "$1"
    if [ "$LOGGING" = true ]; then
        echo "$1" >> "$LOG_FILE"
    fi
}

# Build the find command options based on recursive flag
FIND_OPTS=()
if [ "$RECURSIVE" = false ]; then
    FIND_OPTS+=("-maxdepth" "1")
fi

# Loop through found files
find "$TARGET_DIR" "${FIND_OPTS[@]}" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | while IFS= read -r -d '' file; do
    dimensions=$(identify -format "%w %h" "$file" 2>/dev/null)
    if [ -n "$dimensions" ]; then
        read -r w h <<< "$dimensions"
        if [ "$w" -gt "$MAX_WIDTH" ] || [ "$h" -gt "$MAX_HEIGHT" ]; then
            if [ "$DRY_RUN" = true ]; then
                log_message "[WOULD RESIZE] $file (${w}x${h} -> Max ${MAX_WIDTH}x${MAX_HEIGHT})"
            else
                mogrify -resize "$MAX_SIZE" "$file"
                log_message "[RESIZED]      $file (${w}x${h} -> Max ${MAX_WIDTH}x${MAX_HEIGHT})"
            fi
        else
            log_message "[SKIP]         $file (${w}x${h} is within bounds)"
        fi
    fi
done

# Final notification if log file was created
if [ "$LOGGING" = true ]; then
    echo ""
    echo "Log file saved to: ./${LOG_FILE}"
fi
