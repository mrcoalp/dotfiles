#!/bin/bash

# install dependencies
sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libxdg-basedir-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev uthash-dev libevdev2

# install meson
sudo apt-get install python3 python3-pip python3-setuptools \
                       python3-wheel ninja-build
pip3 install meson

# build
git clone https://github.com/sdhand/compton.git
cd compton
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build

# install
sudo ninja -C build install
