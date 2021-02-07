#!/bin/sh

choice=$(printf "lock\nshutdown\nreboot\nexit" | dmenu -i)

case "$choice" in
	lock) slock ;;
	shutdown) doas poweroff ;;
	reboot) doas reboot ;;
	exit) pkill dwm ;;
esac
