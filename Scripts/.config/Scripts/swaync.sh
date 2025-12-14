#!/bin/bash
killall swaync

swaync
sleep 0.15
notify-send hi
sleep 0.4
swaync-client -t -sw &
