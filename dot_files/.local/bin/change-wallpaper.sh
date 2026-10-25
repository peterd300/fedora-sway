#!/usr/bin/env bash

# Check if a wallpaper path was provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

# Zorg ervoor dat het pad ALTIJD absoluut is (krijgt de volledige mapstructuur mee)
WALLPAPER=$(realpath "$1")

# Sla het pad op voor herstel na een reboot
echo "$WALLPAPER" > "$HOME/.cache/current_wallpaper"

# 1. Run pywal16 to generate color palettes from the image
wal -i "$WALLPAPER" -n -e

# 2. Update Sway's wallpaper background live (met de gefixte SDDM-socketzoeker)
export SWAYSOCK=$(find /run/user/$(id -u) -name "sway-ipc.*.sock" 2>/dev/null | head -n 1)
swaymsg "output * bg \"$WALLPAPER\" fill"


if [ -n "$SWAYSOCK" ]; then
    swaymsg "output * bg \"$WALLPAPER\" fill"
else
    # Als fallback proberen we het via de standaard omgevingsvariabele
    swaymsg "output * bg \"$WALLPAPER\" fill" || echo "Swaymsg kon geen verbinding maken met de socket."
fi

# 3. Reload Foot terminal (sends SIGUSR1 to all running instances)
pkill -USR1 '^foot$'

# 4. Reload Kitty terminal configurations live
pkill -USR1 '^kitty$'

# 5. Signal Waybar to refresh its styles without killing it
pkill -USR2 '^waybar$'

# 6. Reload Mako with the newly generated colors
makoctl reload

notify-send -i "$WALLPAPER" "Theme Updated" "Wallpaper changed to: $(basename "$WALLPAPER")"

