#!/usr/bin/env bash

## Get the touchpad id. The -P means perl regular expressions (for \K)
## the -i makes it case insensitive (better portability) and the -o
## means print only the matched portion. The \K discards anything matched
## before it so this command will print the numeric id only.
TID=$(xinput list | grep -iPo 'touchpad.*id=\K\d+')

PID=$(pgrep -fc toggle)

if [[ $PID -ge 2 ]]
then
	echo "Alrady runing"
else
## Run every second
while :
do
   ## Disable the touchpad if there is a mouse connected
   ## and enable it if there is none.
    xinput list | grep -iq mouse &&  xinput disable "$TID" || xinput enable "$TID" 
    ## wait one second to avoind spamming your CPU
    sleep 1
done
fi
