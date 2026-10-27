#!/usr/bin/env bash

# 1. Force the correct system paths so Waypaper can see your binaries
# export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin:$HOME/.local/bin"

# Check if a wallpaper path was provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

# Dynamically resolve HOME since Waypaper might strip env variables
USER_NAME=$(whoami)
USER_HOME=$(getent passwd "$USER_NAME" | cut -d: -f6)

# Ensure the path is ALWAYS absolute
WALLPAPER=$(realpath "$1")

# Define paths for caching using the resolved USER_HOME
CACHE_DIR="$USER_HOME/.cache"
BLURRED_WALLPAPER="$CACHE_DIR/blurred_wallpaper.png"
CURRENT_WALLPAPER_LOG="$USER_HOME/.cache/current_wallpaper"

# Create the cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Save the path for restoration after a reboot
echo "$WALLPAPER" > "$CURRENT_WALLPAPER_LOG"

# 2. Generate blurred background via ImageMagick for wlogout
# Explicitly checking paths now that PATH is exported
if command -v magick &> /dev/null; then
    magick "$WALLPAPER" -resize 1920x1080^ -gravity center -extent 1920x1080 -blur 0x20 "$BLURRED_WALLPAPER"
elif command -v convert &> /dev/null; then
    convert "$WALLPAPER" -resize 1920x1080^ -gravity center -extent 1920x1080 -blur 0x20 "$BLURRED_WALLPAPER"
else
    # Log the failure to a temporary file if ImageMagick isn't found
    echo "ImageMagick not found in PATH" > "$CACHE_DIR/waypaper_error.log"
fi

# 3. Run pywal16 to generate color palettes from the image
if command -v wal &> /dev/null; then
    wal -i "$WALLPAPER" -n -e
fi

# 4. Update Sway's wallpaper background live
USER_ID=$(id -u "$USER_NAME")
export SWAYSOCK=$(find /run/user/"$USER_ID" -name "sway-ipc.*.sock" 2>/dev/null | head -n 1)

if [ -n "$SWAYSOCK" ] && command -v swaymsg &> /dev/null; then
    swaymsg "output * bg \"$WALLPAPER\" fill"
fi

# 5. Reload terminal instances safely
pkill -USR1 '^foot$'
pkill -USR1 '^kitty$'

# 6. Signal Waybar to refresh its styles
pkill -USR2 '^waybar$'

# 7. Reload Mako
if command -v makoctl &> /dev/null; then
    makoctl reload
fi

# 8. Refresh wlogout if running
if pkill -0 '^wlogout$'; then
    pkill '^wlogout$'
    wlogout &
fi

# Send desktop notification
if command -v notify-send &> /dev/null; then
    notify-send -i "$WALLPAPER" "Theme Updated" "Wallpaper changed to: $(basename "$WALLPAPER")"
fi
