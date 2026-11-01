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
    local desc="" cat=""
    local re_tag='^[[:space:]]*##[[:space:]]*\[([^]]+)\][[:space:]]*(.*)'
    local re_bind='^[[:space:]]*bind(sym|code)[[:space:]]+([^[:space:]]+)[[:space:]]+(.+)'
    local re_inc='^[[:space:]]*include[[:space:]]+(.+)'

    while IFS= read -r line; do
        if [[ "$line" =~ $re_inc ]]; then
            for sub_file in ${BASH_REMATCH[1]}; do
                sub_file="${sub_file/#\~/$HOME}"
                [[ -f "$sub_file" ]] && parse_bindings "$sub_file"
            done
        elif [[ "$line" =~ $re_tag ]]; then
            cat="${BASH_REMATCH[1]}"
            desc="${BASH_REMATCH[2]}"
        elif [[ "$line" =~ $re_bind ]]; then
            if [[ -n "$desc" ]]; then
                key="${BASH_REMATCH[2]//\$mod/Super}"
                echo "$cat|$key|$desc" >> "$TMP_RAW"
            fi
            desc=""
        fi
    done < "$1"
}

parse_bindings "$CONFIG_FILE"

# Build the layout: grouped by category, "keybind - explanation"
sort -t'|' -k1,1 -s "$TMP_RAW" | awk -F'|' '
    $1 != prev {
        if (NR > 1) print ""
        print "─── [ " toupper($1) " ] ─────────────────────────"
        prev = $1
    }
    { printf "%-24s - %s\n", $2, $3 }
' > "$TMP_FINAL"

# Theme validation for Pywal integration
THEME_FLAG=""
[[ -f "$ROFI_THEME" ]] && THEME_FLAG="-theme $ROFI_THEME"

# Pipe organized categories directly to Rofi
cat "$TMP_FINAL" | rofi -dmenu \
    -i \
    -p "    Sway Shortcuts" \
    $THEME_FLAG \
    -theme-str 'window { width: 55%; border: 2px; border-radius: 8px; } listview { lines: 25; }'
