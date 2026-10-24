#!/usr/bin/env bash

# Check if a wallpaper path was provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

WALLPAPER="$1"

# Sla het pad op voor herstel na een reboot
echo "$WALLPAPER" > "$HOME/.cache/current_wallpaper"

# 1. Run pywal16 to generate color palettes from the image
wal -i "$WALLPAPER" -n

# 2. Update Sway's wallpaper background live
swaymsg "output * background $WALLPAPER fill"

# 3. Reload Foot terminal (sends SIGUSR1 to all running instances)
pkill -USR1 '^foot$'

# 4. Reload Kitty terminal configurations live
pkill -USR1 '^kitty$'

# 5. Signal Waybar to refresh its styles without killing it
pkill -USR2 '^waybar$'

# 6. Reload Mako with the newly generated colors
makoctl reload

notify-send -i "$WALLPAPER" "Theme Updated" "Wallpaper changed to: $(basename "$WALLPAPER")"

