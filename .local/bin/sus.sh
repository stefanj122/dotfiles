#!/usr/bin/bash

# Only exported variables can be used within the timer's command.
display="$(xrandr | awk '/ primary/{print $1}')"
pid=$(pgrep -f xidlehook)

 # if  pgrep -f xidlehook > 0 #&& pgrep -f light-locker > 0
 # then
 # 	echo "Xidlehook and light-locker is working."
 # else
 
 if [ -z "$pid" ]
 then
     dunstify "Xidlehook is running." -a "Suspend"
	# Run xidlehook
	xidlehook \
	  `# Don't lock when there's audio playing` \
	  --not-when-audio \
	  `# Dim the screen after 300 seconds, undim if user becomes active` \
	  --timer 300 \
	    "xrandr --output $display --brightness .1" \
	    "xrandr --output $display --brightness 1" \
	  `# Undim & lock after 300 more seconds` \
	  --timer 300 \
        "xrandr --output $display --brightness .1; slock" \
	    "xrandr --output $display --brightness 1" \
	   ` #"xrandr --output $display --brightness .1; betterlockscreen -l" \
	  # Finally, suspend after 10 min it locks` \
	  --timer 600\
	    "systemctl suspend" \
	    "xrandr --output $display --brightness 1"


 else
     killall xidlehook &
     dunstify -a "Suspend" "Xidlehook is stopped."
 fi
