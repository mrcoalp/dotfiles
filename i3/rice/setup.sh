#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

function main() {
	local xresources_path="$script_dir/xresources"
	local wallpaper_path="/media/data-storage/pictures/wallpaper.png"
	local system="Rice Setup"

	notify-send -u low "$system" "Rice setup started"

	xsetroot -solid "#11111b"
	xrdb -remove

	if [ -f "$xresources_path" ]; then
		xrdb -merge "$xresources_path"
		notify-send -u low "$system" "Xresources applied"
	fi

	if [ -f "$wallpaper_path" ]; then
		feh --no-fehbg --bg-fill "$wallpaper_path"
		notify-send -u low "$system" "Wallpaper applied"
	fi

	notify-send -u low "$system" "Rice setup finished"
}

main
