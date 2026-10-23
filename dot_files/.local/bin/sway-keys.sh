#!/usr/bin/env bash

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/sway/config"
ROFI_THEME="$HOME/.cache/wal/colors-rofi-dark.rasi"

if [[ ! -f "$CONFIG_FILE" ]]; then
    notify-send "Sway Error" "Config file not found" -u critical
    exit 1
fi

# Temporary storage files for sorting
TMP_RAW=$(mktemp)
TMP_FINAL=$(mktemp)

# Clean up files on exit
trap 'rm -f "$TMP_RAW" "$TMP_FINAL"' EXIT

# Extract all keybindings recursively
parse_bindings() {
    cat "$1" | while read -r line; do
        if [[ "$line" =~ ^[[:space:]]*include[[:space:]]+(.+) ]]; then
            for sub_file in ${BASH_REMATCH}; do
                [[ -f "$sub_file" ]] && parse_bindings "$sub_file"
            done
        elif [[ "$line" =~ ^[[:space:]]*bind(sym|code)[[:space:]]+([^[:space:]]+)[[:space:]]+(.+) ]]; then
            KEY="${BASH_REMATCH}"
            ACTION="${BASH_REMATCH}"
            ACTION=$(echo "$ACTION" | sed 's/[[:space:]]*#.*$//') # Strip inline comments
            echo "$KEY|$ACTION" >> "$TMP_RAW"
        fi
    done
}

parse_bindings "$CONFIG_FILE"

# Build the categorized layout list
{
    echo "─── [ APPLICATIONS & LAUNCHERS ] ──────────────────────────"
    grep -E 'exec (kitty|foot|thunar|geany|imv|rofi|wofi|firefox|chromium|discord|spotify)' "$TMP_RAW" | sort -u | awk -F'|' '{printf "%-22s │ %s\n", $1, $2}'
    echo ""
    
    echo "─── [ WINDOW MANAGEMENT & MOVING ] ────────────────────────"
    grep -E '(move|focus|kill|fullscreen|floating|sticky|scratchpad)' "$TMP_RAW" | grep -v -E '(resize|grow|shrink)' | sort -u | awk -F'|' '{printf "%-22s │ %s\n", $1, $2}'
    echo ""
    
    echo "─── [ RESIZING & LAYOUTS ] ────────────────────────────────"
    grep -E '(resize|grow|shrink|layout|splith|splitv)' "$TMP_RAW" | sort -u | awk -F'|' '{printf "%-22s │ %s\n", $1, $2}'
    echo ""
    
    echo "─── [ SYSTEM CONTROLS & AUDIO ] ───────────────────────────"
    grep -E '(XF86|volume|brightness|exit|reload|restart|lock)' "$TMP_RAW" | sort -u | awk -F'|' '{printf "%-22s │ %s\n", $1, $2}'
    echo ""
    
    echo "─── [ WORKSPACES ] ────────────────────────────────────────"
    grep -E 'workspace' "$TMP_RAW" | grep -v -E '(move|focus|exec)' | sort -u | awk -F'|' '{printf "%-22s │ %s\n", $1, $2}'
    echo ""
    
    echo "─── [ OTHER SHORTCUTS ] ───────────────────────────────────"
    # Catch any leftover binds that didn't match the specific filters above
    grep -v -E 'exec (kitty|foot|thunar|geany|imv|rofi|wofi|firefox|chromium|discord|spotify)|(move|focus|kill|fullscreen|floating|sticky|scratchpad)|(resize|grow|shrink|layout|splith|splitv)|(XF86|volume|brightness|exit|reload|restart|lock)|workspace' "$TMP_RAW" | sort -u | awk -F'|' '{printf "%-22s │ %s\n", $1, $2}'
} > "$TMP_FINAL"

# Theme validation for Pywal integration
THEME_FLAG=""
[[ -f "$ROFI_THEME" ]] && THEME_FLAG="-theme $ROFI_THEME"

# Pipe organized categories directly to Rofi
cat "$TMP_FINAL" | rofi -dmenu \
    -i \
    -p "    Sway Shortcuts" \
    $THEME_FLAG \
    -theme-str 'window { width: 55%; border: 2px; border-radius: 8px; } listview { lines: 25; }'
