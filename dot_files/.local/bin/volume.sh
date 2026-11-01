#!/bin/bash
# usage: volume.sh up|down|mute

sink=@DEFAULT_AUDIO_SINK@

case "$1" in
    up)   wpctl set-volume -l 1.0 "$sink" 5%+ ;;
    down) wpctl set-volume "$sink" 5%- ;;
    mute) wpctl set-mute "$sink" toggle ;;
    *)    echo "usage: $0 up|down|mute" >&2; exit 1 ;;
esac

out=$(wpctl get-volume "$sink")
val=$(awk '{printf "%d", $2 * 100}' <<< "$out")

if grep -q MUTED <<< "$out"; then
    notify-send -a osd -u low -t 1500 \
        -h string:x-canonical-private-synchronous:volume \
        -h int:value:0 \
        "Volume: muted"
else
    notify-send -a osd -u low -t 1500 \
        -h string:x-canonical-private-synchronous:volume \
        -h int:value:"$val" \
        "Volume: ${val}%"
fi
