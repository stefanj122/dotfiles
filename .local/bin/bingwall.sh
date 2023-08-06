#!/bin/sh

feh --bg-fill /home/stefanj/Pictures/bingwall.png

PID=$(pgrep -fc bingwall)

if [[ $PID -ge 2 ]]
then
	echo "Bing wallpapers is running."
else
	while :
	do

		urlpath=$( \
		curl "https://www.bing.com/HPImageArchive.aspx?format=rss&idx=0&n=1&mkt=en-US" \
		| xmllint --xpath "/rss/channel/item/link/text()" - \
		| sed 's/1366x768/1920x1080/g' \
		)
		curl "https://www.bing.com$urlpath" --output /home/stefanj/Pictures/bingwall.png
    sleep 3600
		feh --bg-fill /home/stefanj/Pictures/bingwall.png
	done
fi
