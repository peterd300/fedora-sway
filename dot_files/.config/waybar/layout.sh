#!/usr/bin/env bash
# Waybar script for display which tiling mode sway is
#


get_layout() {
  swaymsg -t get_tree | jq -r '
    def find(p): . as $n
      | if .focused then {n: $n, p: p}
        else ((.nodes + .floating_nodes)[]? | find($n)) end;
    first(find(null))
    | if .n.type == "floating_con" then "floating"
      elif .n.type == "workspace" then "empty"
      else (.p.layout // "empty") end'
}

emit() {
  l=$(get_layout)
  printf '{"alt":"%s","class":"%s"}\n' "$l" "$l"
}

emit
swaymsg -t subscribe -m '["window","workspace"]' | while read -r _; do emit; done
