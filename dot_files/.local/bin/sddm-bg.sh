#!/bin/bash

# Define file paths
TARGET_FILE="/usr/share/sddm/themes/03-sway-fedora/theme.conf"
SOURCE_FILE="$HOME/.cache/blurred_wallpaper.png"

# Check if the target file exists
if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: Target file $TARGET_FILE does not exist." >&2
    exit 1
fi

# Check if the source wallpaper exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Source wallpaper $SOURCE_FILE does not exist." >&2
    exit 1
fi

# Escape forward slashes in the path for sed compatibility
ESCAPED_PATH=$(echo "$SOURCE_FILE" | sed 's/\//\\\//g')

# Replace the specific default.jxl line with the new path using sudo
sudo sed -i "s|^background=/usr/share/backgrounds/default.jxl|background=$ESCAPED_PATH|" "$TARGET_FILE"

# Verify the change
if [ $? -eq 0 ]; then
    echo "Successfully updated SDDM background to: $SOURCE_FILE"
else
    echo "Failed to update the background." >&2
    exit 1
fi
