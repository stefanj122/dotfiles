#!/bin/sh

(pkill -f 'xidlehook --timer 300 systemctl suspend')&
