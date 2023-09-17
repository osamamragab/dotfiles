#!/bin/sh

minspeed=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq)
maxspeed=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
setspeed="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

case "$1" in
	button/power)
		case "$2" in
			PBTN|PWRF)
				logger "PowerButton pressed: $2, shutting down..."
				shutdown -P now
				;;
			*) logger "ACPI action undefined: $2" ;;
		esac
		;;
	button/sleep)
		case "$2" in
			SBTN|SLPB)
				# suspend-to-ram
				logger "Sleep Button pressed: $2, suspending..."
				zzz
				;;
			*) logger "ACPI action undefined: $2" ;;
		esac
		;;
	ac_adapter)
		case "$2" in
			AC|ACAD|ADP0)
				case "$4" in
					00000000) printf '%s' "$minspeed" >"$setspeed" ;;
					00000001) printf '%s' "$maxspeed" >"$setspeed" ;;
				esac
				;;
			*) logger "ACPI action undefined: $2" ;;
		esac
		;;
	battery)
		case "$2" in
			BAT0)
				case "$4" in
					00000000) ;;
					00000001) ;;
				esac
				;;
			CPU0) ;;
			*) logger "ACPI action undefined: $2" ;;
		esac
		;;
	button/lid)
		case "$3" in
			close)
				# suspend-to-ram
				logger "LID closed, suspending..."
				zzz
				;;
			open) logger "LID opened" ;;
			*) logger "ACPI action undefined (LID): $2" ;;
		esac
		;;
	video/brightnessdown) ;;
	video/brightnessup );;
	*) logger "ACPI group/action undefined: $1 / $2" ;;
esac
