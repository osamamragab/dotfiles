#!/bin/sh

[ "$1" = "up" ] && pamixer --allow-boost -i 5
[ "$1" = "down" ] && pamixer --allow-boost -d 5
[ "$1" = "toggle" ] && pamixer -t

pkill -RTMIN+7 dwmblocks
