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
syndaemon -i 0.5 -t -K -d &

#xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Enabled' 1 &
#xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1 &
bingwall.sh &
run "nm-applet "&
run "optimus-manager-qt "&
