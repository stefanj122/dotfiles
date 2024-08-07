#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
dir="$HOME/.config/rofi/powermenu/type-5"
theme='style-2'

# CMDs
lastlogin="$(last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7)"
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostnamectl hostname)

# Options
gpu=$(printf '\xEE\xA6\xA2')
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''
nvidia='N'
intel='I'
hybrid='H'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p " $USER@$host" \
		-mesg " Last Login: $lastlogin |  Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -en "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$gpu\n$suspend\n$logout\n$lock\n$reboot\n$shutdown" | rofi_cmd
}

run_rofi2() {
	echo -e "$nvidia\n$intel\n$hybrid" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--hibernate' ]]; then
			systemctl hibernate
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == 'awesome' ]]; then
				pkill $DESKTOP_SESSION
			elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
				qdbus org.kde.ksmserver /KSMServer logout 0 0 0
			fi
		fi
	else
		rofi_main
	fi
}
rofi_cmd2() {
	selected="$(run_rofi2)"
	echo $nvidia
	case ${selected} in
	$nvidia)
		rofi_cmd3 --nvidia
		;;
	$intel)
		rofi_cmd3 --intel
		;;
	$hybrid)
		rofi_cmd3 --hybrid
		;;
	*)
		rofi_main
		;;
	esac
}

rofi_cmd3() {
	selected="$(confirm_exit)"
	if [[ $selected == "$yes" ]]; then
		if [[ $1 == '--nvidia' ]]; then
			optimus-manager --switch nvidia --no-confirm
		elif [[ $1 == '--intel' ]]; then
			optimus-manager --switch integrated --no-confirm
		elif [[ $1 == '--hybrid' ]]; then
			optimus-manager --switch hybrid --no-confirm
		fi
	else
		rofi_cmd2
	fi
}

rofi_main() {
	# Actions
	chosen="$(run_rofi)"
	case ${chosen} in
	$shutdown)
		run_cmd --shutdown
		;;
	$reboot)
		run_cmd --reboot
		;;
	$gpu)
		rofi_cmd2
		;;
	$lock)
		if [[ -x '/usr/bin/betterlockscreen' ]]; then
			betterlockscreen -l
		elif [[ -x '/usr/bin/i3lock' ]]; then
			i3lock
		fi
		;;
	$suspend)
		run_cmd --suspend
		;;
	$logout)
		run_cmd --logout
		;;
	esac
}
rofi_main
