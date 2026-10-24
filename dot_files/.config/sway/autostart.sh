#!/usr/bin/env bash
# Wacht heel even tot Sway volledig is opgestart en schermen actief zijn
sleep 1

if [ -f "$HOME/.cache/current_wallpaper" ]; then
    WALLPAPER=$(cat "$HOME/.cache/current_wallpaper")

    # Herstel pywal cache
    wal -r -n

    # Zet de achtergrond
    swaymsg "output * background $WALLPAPER fill"
fi
