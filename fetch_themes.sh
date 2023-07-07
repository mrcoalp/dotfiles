#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

alacritty_dir="$script_dir/alacritty/themes/tokyonight"
tmux_dir="$script_dir/tmux/themes/tokyonight"

mkdir -p "$alacritty_dir"
mkdir -p "$tmux_dir"

folke_repo="https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras"
flavours="day moon night storm"

for flavour in $flavours; do
	echo "fetching tokyonight::$flavour for alacritty..."
	curl -s -o "$alacritty_dir/$flavour.toml" "$folke_repo/alacritty/tokyonight_$flavour.toml"

	echo "fetching tokyonight::$flavour for tmux..."
	curl -s -o "$tmux_dir/$flavour.tmux" "$folke_repo/tmux/tokyonight_$flavour.tmux"
done
