#!/usr/bin/env bash

wget "https://github.com/wez/wezterm/releases/download/20230408-112425-69ae8472/wezterm-20230408-112425-69ae8472.Ubuntu22.04.deb" -O /tmp/wezterm.deb
sudo dpkg -i /tmp/wezterm.deb
rm /tmp/wezterm.deb
