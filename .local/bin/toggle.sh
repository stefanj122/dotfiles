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
while :
do
    ID=$(xinput | grep 'HyperX' | awk '{print $7}' | grep 'id' | cut -d '=' -f2)
   ## Disable the touchpad if there is a mouse connected
   ## and enable it if there is none.
##    xinput list | grep -iq mouse &&  xinput disable "$TID" && xinput set-prop 'Logitech G203 Prodigy Gaming Mouse' 'libinput Accel Profile Enabled' 0, 1 && xinput set-prop 'Logitech G203 Prodigy Gaming Mouse' 'libinput Accel Speed' 0.5 || xinput enable "$TID"
    if xinput list | grep -iq hyperx ; then
	    	xinput disable "$TID" &
	    	xinput set-prop "$ID" 'libinput Accel Profile Enabled' 0, 1, 0 &
	    	xinput set-prop "$ID" 'libinput Accel Speed' 0.25 &
    else
	    	xinput enable "$TID" &
	    	xinput set-prop "$TID" 'libinput Tapping Enabled' 1 &
	    	xinput set-prop "$TID" 'libinput Natural Scrolling Enabled' 1 &
    fi
    ## wait one second to avoind spamming your CPU
    sleep 1
done
#fi
