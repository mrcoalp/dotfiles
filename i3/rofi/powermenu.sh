#!/usr/bin/env bash

lang_pc_shutdown="Shutdown"
lang_pc_reboot="Reboot"
lang_pc_logout="Log out"
lang_notification_name="Power Manager"
lang_notificaton_shutdown="A power off request has been sent. The computer should shut down in a moment."

# Icons
lang_pc_shutdown="🚪 $lang_pc_shutdown"
lang_pc_reboot="🔃 $lang_pc_reboot"
lang_pc_logout="👥 $lang_pc_logout"

selected=$(
	printf "%s\n%s\n%s\n" \
		"$lang_pc_shutdown" "$lang_pc_reboot" "$lang_pc_logout" |
		rofi -dmenu -p "powermenu" -lines 3 -i
)

case $selected in
"$lang_pc_shutdown")
	notify-send "$lang_notification_name" "$lang_notificaton_shutdown"
	systemctl poweroff
	;;

"$lang_pc_reboot")
	notify-send "$lang_notification_name" "$lang_notificaton_shutdown"
	systemctl reboot
	;;

"$lang_pc_logout")
	i3-msg exit
	;;
esac
