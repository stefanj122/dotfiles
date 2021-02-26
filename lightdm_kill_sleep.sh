#!/bin/sh

(pkill xidlehook)&
(setxkbmap -layout us,rs -variant ,latin) &
