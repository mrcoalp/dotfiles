#!/usr/bin/env bash

# update package list
sudo apt-get update

# install required packages
sudo apt-get install --yes --no-install-recommends \
	dex \
	lxpolkit \
	dunst \
	xss-lock \
	i3lock \
	picom \
	arandr \
	brightnessctl \
	playerctl \
	rofi \
	lxappearance \
	i3

# add user to video group
sudo usermod -a -G video "$USER"

# link configuration files if they don't exist
if [ ! -d "$HOME/.config/i3" ]; then
	SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
	ln -s "$SCRIPT_DIR/../i3" "$HOME/.config/i3"
fi
