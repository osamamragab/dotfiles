#!/bin/sh

set -eu

ssid="$(wpa_cli list_networks | awk -F '\t' -v ID="$WPA_ID" 'ID==$1 {print $2}')"
case "$2" in
	CONNECTED)
		notify-send -a wpa_supplicant -c network.connected "WPA supplicant" "$1: [$ssid] connected"
		;;
	DISCONNECTED)
		notify-send -a wpa_supplicant -c network.disconnected "WPA supplicant" "$1: [$ssid] disconnected"
		;;
esac
