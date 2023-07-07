#!/usr/bin/env bash

function main() {
	local connected_outputs=""
	local disconnected_outputs=""
	local previous_output=""

	connected_outputs=$(xrandr | grep " connected" | cut -d" " -f1)
	disconnected_outputs=$(xrandr | grep " disconnected" | cut -d" " -f1)

	local cmd="xrandr"

	for output in $connected_outputs; do
		cmd="$cmd --output $output --auto"

		if [ -n "$previous_output" ]; then
			cmd="$cmd --left-of $previous_output"
		else
			cmd="$cmd --primary"
		fi

		previous_output=$output
	done

	for output in $disconnected_outputs; do
		cmd="$cmd --output $output --off"
	done

	command $cmd

	local config_dir="$HOME/.config/i3"

	if [ -f "$config_dir/rice/setup.sh" ]; then
		bash "$config_dir/rice/setup.sh"
	fi
}

main
