#!/bin/bash
intern="$(xrandr | grep ' connected' | awk '{print $1}' | head -n 1)"
extern="$(xrandr | grep ' connected' | awk '{print $1}' | tail -n 1)"
disconnected="$(xrandr | grep -e 'disconnected [0-9]*x[0-9]*+0+0' | awk '{print $1}')"

options="$1"

echo $disconnected
if [ -n "$disconnected" ]; then
    xrandr --output "$disconnected" --off
fi
if [ $intern == $extern ]; then
    exit 0
fi

if [[ $options == '--opt1' ]]; then
	xrandr --output "$extern" --off --output "$intern" --auto
elif [[ $options == '--opt2' ]]; then
	xrandr --output "$extern" --auto --right-of "$intern" --auto
elif [[ $options == '--opt3' ]]; then
	xrandr --output "$extern" --auto --left-of "$intern" --auto
elif [[ $options == '--opt4' ]]; then
	xrandr --output "$extern" --auto --output "$intern" --off
fi
feh --bg-fill ~/Pictures/bingwall.png
exit 0
