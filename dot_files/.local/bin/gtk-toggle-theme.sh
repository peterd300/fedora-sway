#!/usr/bin/env bash
# Toggle light/dark for GTK3 (gsettings + settings.ini) and Geany.
# Usage: toggle-theme.sh [--no-restart]   (--no-restart: don't restart Geany)

set -u

GTK_INI="$HOME/.config/gtk-3.0/settings.ini"
GEANY_CONF="$HOME/.config/geany/geany.conf"
GEANY_LIGHT="abc-light.conf"
GEANY_DARK="abc-dark.conf"
THEME_DIRS=(/usr/share/themes "$HOME/.themes" "$HOME/.local/share/themes")

RESTART_GEANY=1
[[ "${1:-}" == "--no-restart" ]] && RESTART_GEANY=0

# --- helpers -----------------------------------------------------------------

theme_exists() {
    local d
    for d in "${THEME_DIRS[@]}"; do
        [[ -d "$d/$1" ]] && return 0
    done
    return 1
}

# set_ini_key FILE SECTION KEY VALUE
# Replaces KEY if present, otherwise adds it to SECTION (creating it if needed).
set_ini_key() {
    local file="$1" section="$2" key="$3" value="$4"
    mkdir -p "$(dirname "$file")"
    [[ -f "$file" ]] || : > "$file"

    if grep -q "^${key}=" "$file"; then
        sed -i "s|^${key}=.*|${key}=${value}|" "$file"
    elif grep -q "^\[${section}\]" "$file"; then
        sed -i "/^\[${section}\]/a ${key}=${value}" "$file"
    else
        printf '\n[%s]\n%s=%s\n' "$section" "$key" "$value" >> "$file"
    fi
}

# --- detect current mode -----------------------------------------------------

CURRENT_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")
CURRENT_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")

if [[ "${CURRENT_THEME,,}" == *dark ]] || [[ "$CURRENT_SCHEME" == "prefer-dark" ]]; then
    MODE_NOW=dark
else
    MODE_NOW=light
fi

# Base (light) theme name: strip any -dark / dark suffix, any case
BASE_THEME=$(echo "$CURRENT_THEME" | sed -E 's/-?[Dd]ark$//')

# --- work out target ---------------------------------------------------------

if [[ "$MODE_NOW" == dark ]]; then
    echo "Switching to LIGHT mode..."
    TARGET_THEME="$BASE_THEME"
    TARGET_SCHEME="prefer-light"
    PREFER_DARK=0
    GEANY_SCHEME="$GEANY_LIGHT"
else
    echo "Switching to DARK mode..."
    TARGET_THEME=""
    for candidate in "${BASE_THEME}-dark" "${BASE_THEME}-Dark" "${BASE_THEME}Dark"; do
        if theme_exists "$candidate"; then
            TARGET_THEME="$candidate"
            break
        fi
    done
    if [[ -z "$TARGET_THEME" ]]; then
        TARGET_THEME="${BASE_THEME}-dark"
        echo "Warning: no dark variant of '$BASE_THEME' found; trying '$TARGET_THEME' anyway." >&2
    fi
    TARGET_SCHEME="prefer-dark"
    PREFER_DARK=1
    GEANY_SCHEME="$GEANY_DARK"
fi

# --- apply GTK settings ------------------------------------------------------

gsettings set org.gnome.desktop.interface color-scheme "$TARGET_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$TARGET_THEME"

# settings.ini is read by many GTK3 apps and overrides gsettings in some
# cases, so keep it in sync instead of leaving hardcoded values behind.
set_ini_key "$GTK_INI" "Settings" "gtk-theme-name" "$TARGET_THEME"
set_ini_key "$GTK_INI" "Settings" "gtk-application-prefer-dark-theme" "$PREFER_DARK"

# --- Geany -------------------------------------------------------------------
# Geany rewrites geany.conf on exit, so it must be closed BEFORE editing it.
# Note: closing Geany loses unsaved changes in open files.

GEANY_WAS_RUNNING=0
if pgrep -x geany > /dev/null; then
    GEANY_WAS_RUNNING=1
fi

if [[ $GEANY_WAS_RUNNING -eq 1 && $RESTART_GEANY -eq 1 ]]; then
    pkill -x geany
    for _ in $(seq 1 20); do
        pgrep -x geany > /dev/null || break
        sleep 0.15
    done
    # Last resort if it ignored SIGTERM
    pgrep -x geany > /dev/null && { pkill -9 -x geany; sleep 0.3; }
    rm -f "$HOME/.config/geany/geany_socket_"*
fi

# Only touch the config if Geany isn't running (or we just closed it),
# otherwise Geany would overwrite our change when it exits.
if ! pgrep -x geany > /dev/null; then
    set_ini_key "$GEANY_CONF" "geany" "color_scheme" "$GEANY_SCHEME"
else
    echo "Geany still running; its colour scheme will update next time you run this with it closed."
fi

if [[ $GEANY_WAS_RUNNING -eq 1 && $RESTART_GEANY -eq 1 ]]; then
    setsid geany > /dev/null 2>&1 &
fi

# --- Thunar ------------------------------------------------------------------
if pgrep -x thunar > /dev/null; then
    thunar -q 2>/dev/null
    for _ in $(seq 1 20); do
        pgrep -x thunar > /dev/null || break
        sleep 0.15
    done
    setsid thunar > /dev/null 2>&1 &
fi
