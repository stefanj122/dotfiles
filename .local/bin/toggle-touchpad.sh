#!/bin/bash

# Lua parser (hyprland.lua) ne podržava `hyprctl keyword` -- vraća
# "keyword can't work with non-legacy parsers. Use eval." i to sa exit 0,
# pa greška prolazi nezapaženo. Runtime izmena ide preko `hyprctl eval`.

TOUCHPAD="ven_04f3:00-04f3:32aa-touchpad"

set_enabled() {
    hyprctl eval "hl.device({ name = \"$TOUCHPAD\", enabled = $1 })"
}

if [[ $1 == "disable" ]]; then
    set_enabled false
elif [[ $1 == "enable" ]]; then
    set_enabled true
else
    echo "usage: ${0##*/} enable|disable" >&2
    exit 1
fi
