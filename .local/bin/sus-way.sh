#!/usr/bin/bash

# Only exported variables can be used within the timer's command.
display="$(xrandr | awk '/ primary/{print $1}')"
pid=$(pgrep -f hypridle)

 # if  pgrep -f xidlehook > 0 #&& pgrep -f light-locker > 0
 # then
 # 	echo "Xidlehook and light-locker is working."
 # else
 
 if [ -z "$pid" ]
 then
     dunstify -r 1 "Hypridle is running." -a "Suspend"
	# Run xidlehook
    hypridle


 else
     killall hypridle &
     dunstify -r 1 -a "Suspend" "Hypridle is stopped."
 fi
