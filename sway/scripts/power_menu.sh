#!/bin/bash

opt_lock="Lock"
opt_suspend="Suspend"
opt_logout="Log out"
opt_reboot="Reboot"
opt_poweroff="Power off"

selected=$(echo -e "$opt_lock\n$opt_suspend\n$opt_logout\n$opt_reboot\n$opt_poweroff" | wofi --width 250 --height 220 --dmenu --cache-file /dev/null --prompt "Power Menu")

case $selected in
	"$opt_lock")
		swaylock -f -c 000000
		;;
	"$opt_suspend")
		swaylock -f -c 000000 &
		sleep 0.5
		systemctl suspend
		;;
	"$opt_logout")
		swaymsg exit
		;;
	"$opt_reboot")
		systemctl reboot
		;;
	"$opt_poweroff")
		systemctl poweroff
		;;
esac
