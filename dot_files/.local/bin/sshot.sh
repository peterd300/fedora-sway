#!/usr/bin/env bash
# sshot.sh - screenshot helper for Sway using grim
# Requires: grim, slurp, jq, (optional) wl-clipboard

DIR="${SCREENSHOT_DIR:-$HOME/Screenshots}"   # you wrote "Screenshost", change here if intended
mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
CLIP=0

usage() {
    cat <<EOF
Usage: ${0##*/} [-c] <option>

Options:
  full      Full screenshot of the active workspace (focused output)
  area      Select an area with the mouse
  window    Focused window
  output    Pick an output (monitor) by clicking it
  -c        Also copy the screenshot to the clipboard (wl-copy)
  -h        Show this help

Screenshots are saved in: $DIR
EOF
}

notify() {
    command -v notify-send >/dev/null && notify-send "Screenshot" "$1"
    echo "$1"
}

finish() {
    if [[ -s "$FILE" ]]; then
        (( CLIP )) && wl-copy < "$FILE"
        notify "Saved: $FILE"
    else
        rm -f "$FILE"
        notify "Screenshot cancelled or failed"
        exit 1
    fi
}

[[ "$1" == "-c" ]] && { CLIP=1; shift; }

case "$1" in
    full)
        OUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
        grim -o "$OUT" "$FILE"
        finish
        ;;
    area)
        GEOM=$(slurp) || exit 1
        grim -g "$GEOM" "$FILE"
        finish
        ;;
    window)
        GEOM=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true and .pid?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
        [[ -z "$GEOM" ]] && { notify "No focused window"; exit 1; }
        grim -g "$GEOM" "$FILE"
        finish
        ;;
    output)
        GEOM=$(slurp -o) || exit 1
        grim -g "$GEOM" "$FILE"
        finish
        ;;
    -h|--help|"")
        usage
        ;;
    *)
        echo "Unknown option: $1" >&2
        usage
        exit 1
        ;;
esac
