#!/usr/bin/env bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

if  pgrep -f xidlehook > 0 #&& pgrep -f light-locker > 0 
then
	echo "Xidlehook and light-locker is working."
else

#	(light-locker) &

	# Run xidlehook
	xidlehook \
	  `# Don't lock when there's audio playing` \
	  --not-when-audio \
	  `# Dim the screen after 60 seconds, undim if user becomes active` \
	  --timer 300 \
	    'brightnessctl s 10%' \
	    'brightnessctl s 100%' \
	  `# Undim & lock after 10 more seconds` \
	  --timer 300 \
	    'brightnessctl s 10%; xtrlock' \
	    'brightnessctl s 100%' \
	  `# Finally, suspend an hour after it locks` \
	  --timer 600\
	    'systemctl suspend' \
	    'brightnessctl s 100%'
	    
fi

