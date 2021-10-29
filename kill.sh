#!/usr/bin/env bash

if  pgrep -f xidlehook > 0 && pgrep -f light-locker > 0
then
    (killall light-locker) &
    (killall xidlehook) &
    notify-send 'Suspending is disabled!'
else
    notify-send 'Suspending is enabled!'
    exec /usr/bin/sus.sh
fi


