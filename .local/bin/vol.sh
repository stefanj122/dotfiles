#!/bin/bash
# changeVolume

# Arbitrary but unique message tag
msgTag="myvolume"

# Change the volume using alsa(might differ if you use pulseaudio)
amixer -c 0 set Master "$@" > /dev/null

# Query amixer for the current volume and whether or not the speaker is muted
# volume="$(amixer get Master | tail -1 | awk '{print $5}' | sed 's/[^0-9]*//g')"
volume="$(pamixer --get-volume)"
mute="$(amixer -c 0 get Master | tail -1 | awk '{print $6}' | sed 's/[^a-z]*//g')"
volbar=$(echo "$volume*100/150" | bc -l)
volbar=$(printf %.f $volbar)
if [[ $volume == 0 || "$mute" == "off" ]]; then
    # Show the sound muted notification
    dunstify -a "change" -i audio-volume-muted -h string:x-dunst-stack-tag:$msgTag "Volume muted" -r 15 -t 2000 -I /home/stefanj/.config/awesome1/themes/powerarrow-blue/icons/vol_mute.png
else
    # Show the volume notification
    dunstify -a "change" -i audio-volume-high -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:$volbar "Volume: ${volbar}%" -r 15 -t 2000 -I /home/stefanj/.config/awesome1/themes/powerarrow-blue/icons/vol.png
fi

# Play the volume changed sound
#canberra-gtk-play -i audio-volume-change -d "changeVolume"
