#!/bin/bash

# Fetch workspace information
workspaces=$(hyprctl workspaces -j)
windows=$(hyprctl clients -j)

# Parse the JSON data
inactive_workspaces=$(echo "$workspaces" | jq -r '.[] | select(.windows > 0) | .id')
output=""

for ws in $inactive_workspaces; do
    # Find windows in the inactive workspace
    window_titles=$(echo "$windows" | jq -r ".[] | select(.workspace.id == $ws) | .title")
    if [[ ! -z "$window_titles" ]]; then
        output+="Workspace $ws: $window_titles | "
    fi
done

# Trim trailing separator
echo "${output}"

