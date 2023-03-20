#!/bin/bash
# changeVolume

# Arbitrary but unique message tag
msgTag="mybrightness"


# Query amixer for the current volume and whether or not the speaker is muted
bright="$(brightnessctl | grep 'Current' | cut -d '(' -f 2 | cut -d % -f 1)"
    # Show the volume notification
    dunstify -a "change" -i brightness -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:"$bright" "Brightness: ${bright}%" -r 15 -t 2000 -I /home/stefanj/.config/awesome/themes/powerarrow-blue/icons/bright.png

# Play the volume changed sound
#canberra-gtk-play -i audio-volume-change -d "changeVolume"
