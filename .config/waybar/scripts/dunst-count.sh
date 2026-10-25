#!/usr/bin/env bash

count="$(dunstctl count history 2>/dev/null)"

if [ -z "$count" ]; then
    count=0
fi

if [ "$count" -gt 0 ]; then
    printf '{"text":"%s","tooltip":"%s notifications in history","class":"has-notifications"}\n' "$count" "$count"
else
    printf '{"text":"0","tooltip":"No notifications","class":"no-notifications"}\n'
fi
