#!/bin/bash
intern=eDP-1-1
extern=HDMI-0
extern1=HDMI-1-0
intern1=eDP-1
pom="$(optimus-manager --print-mode | cut -d ':' -f 2)"

if [ $pom == 'nvidia' ]; then
	if xrandr | grep "$extern disconnected"; then
    	xrandr --output "$extern" --off --output "$intern" --auto
	else
    	xrandr --output "$intern" --off --output "$extern" --auto
	fi
elif [ $pom == 'hybrid' ]; then 
	if xrandr | grep "$extern1 connected"; then
	xrandr --output "$extern1" --auto --right-of "$intern1"
	else
	xrandr --output "$extern1" --off
	fi
fi
