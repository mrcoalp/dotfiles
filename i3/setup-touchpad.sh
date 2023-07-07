#!/bin/env bash

function natural_scrolling() {
	local id=$1
	local natural_scrolling_id=0

	# Get id of natural scrolling property
	natural_scrolling_id=$(
		xinput list-props $id |
			grep -i "Natural Scrolling Enabled (" |
			cut -d'(' -f2 | cut -d')' -f1
	)

	# Set the property to true
	xinput --set-prop $id $natural_scrolling_id 1
}

function tap_to_click() {
	local id=$1
	local tap_to_click_id=0

	# Get id of tap to click property
	tap_to_click_id=$(
		xinput list-props $id |
			grep -i "Tapping Enabled (" |
			cut -d'(' -f2 | cut -d')' -f1
	)

	# Set the property to true
	xinput --set-prop $id $tap_to_click_id 1
}

function main() {
	local id=0

	# Get id of touchpad
	id=$(
		xinput list |
			grep -i "Touchpad" |
			cut -d'=' -f2 |
			cut -d'[' -f1
	)

	natural_scrolling $id
	tap_to_click $id
}

main
