#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

numlockx on &
run "sus.sh"
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Tap Action' 0, 0, 0, 0, 1, 3, 2 &
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Two-Finger Scrolling' 1, 1 &
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Scrolling Distance' -86, -88 &
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Off' 2 &
#run "nm-applet &"
