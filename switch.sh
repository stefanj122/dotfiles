#!/usr/bin/env bash

pom1="Nvidia
Hybrid
Integrated"
prompt="Choose:"
pom2="Switch graphic
Power menu"
pom="$(optimus-manager --print-mode | cut -d ':' -f 2)"

cmd=$( echo "$pom2" | dmenu -p "$prompt")


if [ "$cmd" = "Switch graphic" ]; then

    if [ "$pom" == "nvidia" ]; then
        pom1="Hybrid
Integrated"
    elif [ "$pom" == "hybrid" ]; then
        pom1="Nvidia
Integrated"
    else
        pom1="Nvidai
Hybrid"
    fi
#cmd=$("$file" | dmenu "$@" )
    cmd=$( echo "$pom1" | dmenu -p "$prompt")
        if [ "$cmd" == "Nvidia" ]; then
            optimus-manager --switch nvidia --no-confirm &
        elif [ "$cmd" == "Hybrid" ]; then
            optimus-manager --switch hybrid --no-confirm &
        elif [ "$cmd" == "Integrated" ]; then
            optimus-manager --switch integrated --no-confirm &
        else 
            echo "Don't work!!!"
        fi
elif [ "$cmd" == "Power menu" ]; then
    pom1="Reboot
Logout
Sleep
Shutdown"
    cmd=$( echo "$pom1" | dmenu -p "$prompt")
    if [ "$cmd" == "Reboot" ]; then
        systemctl reboot
    elif [ "$cmd" == "Sleep" ]; then
        systemctl suspend
    elif [ "$cmd" == "Shutdown" ]; then
        systemctl poweroff
    elif [ "$cmd" == "Logout" ]; then
        pkill $DESKTOP_SESSION
    fi
fi


