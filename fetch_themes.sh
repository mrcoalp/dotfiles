#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

alacritty_dir="$script_dir/alacritty/themes/tokyonight"
tmux_dir="$script_dir/tmux/themes/tokyonight"

mkdir -p "$alacritty_dir"
mkdir -p "$tmux_dir"

flavours="day moon night storm"

for flavour in $flavours; do
	echo "fetching tokyonight::$flavour for alacritty..."
	curl -s -o "$alacritty_dir/$flavour.yml" "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/alacritty/tokyonight_$flavour.yml"

	echo "fetching tokyonight::$flavour for tmux..."
	curl -s -o "$tmux_dir/$flavour.tmux" "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/tmux/tokyonight_$flavour.tmux"
done
