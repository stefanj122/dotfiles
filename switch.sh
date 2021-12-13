#!/usr/bin/env bash

pom1="Nvidia
Hybrid
Integrated"
prompt="Switch to:"

#cmd=$("$file" | dmenu "$@" )
cmd=$( echo "$pom1" | dmenu -p "$prompt")
    if [ $cmd == "Nvidia" ]; then
        optimus-manager --switch nvidia --no-confirm
    else if [ $cmd == "Hybrid" ]; then
        optimus-manager --switch hybrid --no-confirm
    else if [ $cmd == "Integrated" ]; then
        optimus-manager --switch integrated --no-confirm
    fi

exit 0
