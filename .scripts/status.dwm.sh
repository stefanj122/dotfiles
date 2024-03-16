while true; do
    time=$(date +"%I:%M %p")
    bat=$(cat /sys/class/power_supply/BAT0/capacity) 

	xsetroot -name "$(time)" + "$(bat)"
	sleep 2
done
