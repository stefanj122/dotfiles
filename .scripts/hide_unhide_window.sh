#!/bin/bash

# NAPOMENA: sa lua config-om (hyprland.lua) `hyprctl dispatch` više ne prima
# legacy sintaksu -- sve posle "dispatch" se parsira kao Lua i ide u
# hl.dispatch(...). Zato ovde idu hl.dsp.* pozivi umesto
# "movetoworkspacesilent 88,pid:$pid" / "cyclenext".

stack_file="/tmp/hide_window_pid_stack.txt"
hidden_workspace=88

function hide_window() {
	pid=$(hyprctl activewindow -j | jq -r '.pid')
	[ -z "$pid" ] || [ "$pid" == "null" ] && return 1

	hyprctl dispatch "hl.dsp.window.move({ workspace = $hidden_workspace, window = \"pid:$pid\", follow = false })" || return 1
	echo "$pid" >> "$stack_file"
}

function show_window() {
	[ -s "$stack_file" ] || return 1
	pid=$(tail -1 "$stack_file")
	[ -z "$pid" ] && return 1

	current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
	hyprctl dispatch "hl.dsp.window.move({ workspace = $current_workspace, window = \"pid:$pid\", follow = false })" || return 1
	sed -i '$d' "$stack_file"
	hyprctl dispatch 'hl.dsp.window.cycle_next()'
}

if [ -n "$1" ]; then
	if [ "$1" == "h" ]; then
		hide_window > /dev/null
	else
		show_window > /dev/null
	fi
fi
