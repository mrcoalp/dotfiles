#!/usr/bin/env bash
# shellcheck disable=SC2155

_find_card_profile() {
	pactl list cards |
		grep -m 1 -B 12 "bluez.alias = \"$1\"" |
		grep "Name: " |
		awk '{print $2}'
}
