#!/bin/bash
intern="$(xrandr | awk '/eDP/{print $1}')"
extern="$(xrandr | awk -e '/(HDMI.*)0/{print $1}')"
pom="$(optimus-manager --print-mode | cut -d ':' -f 2)"
positin="$1"

if [ $pom == 'nvidia' ]; then
	if xrandr | grep "$extern disconnected"; then
    	xrandr --output "$extern" --off --output "$intern" --auto
	else
    	xrandr --output "$intern" --off --output "$extern" --auto
	fi
elif [ $pom == 'hybrid' ]; then 
	if xrandr | grep "$extern connected"; then
	xrandr --output "$extern" --auto --"$positin"-of "$intern"
	else
	xrandr --output "$extern" --off
	fi
fi
