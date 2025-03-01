#!/usr/bin/env bash

## Get the touchpad id. The -P means perl regular expressions (for \K)
## the -i makes it case insensitive (better portability) and the -o
## means print only the matched portion. The \K discards anything matched
## before it so this command will print the numeric id only.
TID=$(xinput list | grep -iPo 'Touchpad.*id=\K\d+')
PID=$(pgrep -fc toggle)
i=0
t=0

#if [[ $PID -ge 2 ]]
#then
#	echo "Alrady runing"
#else
## Run every second
while :; do
    ID=$(xinput | grep 'HyperX' | awk '{print $7}' | grep 'id' | cut -d '=' -f2)
    MX=false
    if [ -z $ID ]; then
        ID=$(xinput | grep 'MX Master 3S' | awk '{print $7}' | grep 'id' | cut -d '=' -f2)
        MX=true
    fi
    ## Disable the touchpad if there is a mouse connected
    ## and enable it if there is none.
    ##    xinput list | grep -iq mouse &&  xinput disable "$TID" && xinput set-prop 'Logitech G203 Prodigy Gaming Mouse' 'libinput Accel Profile Enabled' 0, 1 && xinput set-prop 'Logitech G203 Prodigy Gaming Mouse' 'libinput Accel Speed' 0.5 || xinput enable "$TID"
    if [ ! -z $ID ] && [ $i -eq 0 ]; then
        xinput disable "$TID" &
        xinput set-prop "$ID" 'libinput Accel Profile Enabled' 0, 1, 0 &
        xinput set-prop "$ID" 'libinput Accel Speed' -0.25 &
        if [ $MX == true ]; then
            echo 'test'
            solaar config 'MX Master 3S' dpi 400 &
        fi
        i=1
        t=0
    elif [ -z $ID ] && [ $t -eq 0 ]; then
        xinput enable "$TID" &
        enabled=$(xinput list-props 14 | grep 'Device Enabled' | head -n1 | tail -c2)
        if [ $enabled -eq 1 ]; then
            xinput set-prop "$TID" 'libinput Tapping Enabled' 1 &
            xinput set-prop "$TID" 'libinput Natural Scrolling Enabled' 1 &
            t=1
        fi
        if [ $i -eq 1 ]; then
            i=0
        fi
    fi
    ## wait one second to avoind spamming your CPU
    sleep 1
done
#fi
