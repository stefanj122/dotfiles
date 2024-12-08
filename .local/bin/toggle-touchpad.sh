#!/bin/bash

if [[ $1 == "disable" ]]; then
    hyprctl keyword "device[ven_04f3:00-04f3:32aa-touchpad]:enabled" false
elif [[ $1 == "enable" ]]; then
    hyprctl keyword "device[ven_04f3:00-04f3:32aa-touchpad]:enabled" true
fi
