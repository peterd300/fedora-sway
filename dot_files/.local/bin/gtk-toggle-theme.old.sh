#!/usr/bin/env bash

CURRENT_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")
GEANY_CONF="$HOME/.config/geany/geany.conf"

if [[ "$CURRENT_THEME" =~ -[Dd]ark$ ]] || [[ "$CURRENT_THEME" =~ [Dd]ark$ ]]; then
    LIGHT_THEME=$(echo "$CURRENT_THEME" | sed -E 's/-[Dd]ark$//; s/[Dd]ark$//')
    echo "Switching System to LIGHT Mode..."
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme "$LIGHT_THEME"

    # Match Geany background with Light Mode
    if [ -f "$GEANY_CONF" ]; then
        sed -i 's/^color_scheme=.*/color_scheme=abc-light.conf/' "$GEANY_CONF"
    fi
else
    if [ "$CURRENT_THEME" = "Adwaita" ]; then DARK_THEME="Adwaita-dark"; else DARK_THEME="${CURRENT_THEME}-dark"; fi
    echo "Switching System to DARK Mode..."
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme "$DARK_THEME"

    # Match Geany background with Dark Mode
    if [ -f "$GEANY_CONF" ]; then
        sed -i 's/^color_scheme=.*/color_scheme=abc-dark.conf/' "$GEANY_CONF"
    fi
fi

# Hard flush Geany process and instance cache to apply backgrounds cleanly
if pgrep -x "geany" > /dev/null; then
    killall -9 geany 2>/dev/null
    sleep 0.3
    rm -f "$HOME/.config/geany/geany_socket_"*
    geany & disown
fi
