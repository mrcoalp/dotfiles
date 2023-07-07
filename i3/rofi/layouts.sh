#!/usr/bin/env bash

function _apply() {
	local script="$1"

	local system="Screen Layout"
	local name=""

	# Get the name of the script without the extension
	name=$(basename "$script" | cut -d. -f1)

	if [ ! -f "$script" ]; then
		notify-send -u critical "$system" "No '$name' screen layout found"
		exit 1
	fi

	bash "$script"
	status=$?

	if [ $status -ne 0 ]; then
		notify-send -u critical "$system" "Failed to apply '$name' screen layout"
		exit 1
	fi

	notify-send -u low "$system" "'$name' screen layout applied"
}

function main() {
	local layouts_dir="$HOME/.screenlayout"
	local config_dir="$HOME/.config/i3"

	local selected=""
	local opt_home_office="🏠 Home Office"
	local opt_work="🏢 Work"

	selected=$(
		printf "%s\n" \
			"$opt_home_office" "$opt_work" |
			rofi -dmenu -p "layouts" -lines 2 -i
	)

	case $selected in
	"$opt_home_office")
		_apply "$layouts_dir/home-office.sh"
		;;

	"$opt_work")
		_apply "$layouts_dir/work.sh"
		;;
	esac

	if [ -f "$config_dir/rice/setup.sh" ]; then
		bash "$config_dir/rice/setup.sh"
		i3-msg restart
	fi
}

main
