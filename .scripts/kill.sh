#!/usr/bin/env bash

if  pgrep -f xidlehook > 0 #&& pgrep -f light-locker > 0
then
#    (killall light-locker) &
    (killall xidlehook) &
    dunstify -i system-suspend-hibernate 'Suspending is disabled!' -t 4000 -r 17
else
    exec /usr/bin/sus.sh &
    dunstify -i system-suspend-hibernate 'Suspending is enabled!' -t 4000 -r 17
fi


