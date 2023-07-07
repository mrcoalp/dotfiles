#!/usr/bin/env bash

if which picom >/dev/null; then
	echo "Picom already installed"
	exit 1
fi

function install_deps() {
	sudo apt-get --yes install \
		libconfig-dev libdbus-1-dev libegl-dev libev-dev \
		libgl-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev \
		libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev \
		libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev \
		libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev \
		libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev \
		libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev

	return $?
}

function install_picom() {
	git clone --recursive --depth 1 https://github.com/yshui/picom.git /tmp/picom || return 1

	cd /tmp/picom || return 1
	meson --buildtype=release . build || return 1
	ninja -C build install || return 1

	cd - || return 1
	rm -rf /tmp/picom
	return 0
}

if ! install_deps; then
	exit 1
fi

if ! install_picom; then
	exit 1
fi

exit 0
