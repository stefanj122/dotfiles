#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Brightness

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$HOME/.config/rofi/applets/type-3/$style"
mesg="Project"

win_width='600px'
list_col='1'
list_row='4'

option_1='PC screen only\x00icon\x1f/home/stefanj/.local/share/icons/myicons/primary.png'
option_2='Extend screen right\x00icon\x1f/home/stefanj/.local/share/icons/myicons/right.png'
option_3='Extend screen left\x00icon\x1f/home/stefanj/.local/share/icons/myicons/left.png'
option_4='Second screen only\x00icon\x1f/home/stefanj/.local/share/icons/myicons/second.png'

rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme ${theme}
}

run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        hdmi.sh "--opt1"
    elif [[ "$1" == '--opt2' ]]; then
        hdmi.sh "--opt2"
    elif [[ "$1" == '--opt3' ]]; then
        hdmi.sh "--opt3"
    elif [[ "$1" == '--opt4' ]]; then
        hdmi.sh "--opt4"
    fi
}

run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

chosen="$(run_rofi)"
case ${chosen} in
'PC screen only')
    run_cmd --opt1
    ;;
'Extend screen right')
    run_cmd --opt2
    ;;
'Extend screen left')
    run_cmd --opt3
    ;;
'Second screen only')
    run_cmd --opt4
    ;;
esac
