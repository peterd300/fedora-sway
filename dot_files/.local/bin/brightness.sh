#!/bin/bash
# usage: brightness.sh up|down

case "$1" in
    up)   brightnessctl set 5%+ >/dev/null ;;
    down) brightnessctl set 5%- >/dev/null ;;
    *)    echo "usage: $0 up|down" >&2; exit 1 ;;
esac

val=$(brightnessctl -m | cut -d, -f4 | tr -d '%')

notify-send -a osd -u low -t 1500 \
    -h string:x-canonical-private-synchronous:brightness \
    -h int:value:"$val" \
    "Brightness: ${val}%"
