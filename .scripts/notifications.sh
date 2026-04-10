#!/bin/bash

history=$(dunstctl history)

choice=$(echo "$history" | jq -r '.data[0][] | "\(.id.data) | \(.summary.data)"' | rofi -dmenu)

id=$(echo "$choice" | awk '{print $1}')

[ -n "$id" ] && dunstctl history-pop "$id"
