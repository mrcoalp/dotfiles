#!/usr/bin/env bash

which python3 >/dev/null || sudo apt install python3 -y
which pip3 >/dev/null || sudo apt install python3-pip -y
which python3-venv >/dev/null || sudo apt install python3-venv -y

pip3 install xcffib
pip3 install --no-cache-dir cairocffi
pip3 install git+https://github.com/mrcoalp/qtile-progress-widgets.git

cat >tmp.desktop <<EOF
[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Exec=qtile start
Type=Application
Keywords=wm;tiling
EOF
sudo mv tmp.desktop /usr/share/xsessions/qtile.desktop

if [ ! -d "/usr/share/wayland-sessions" ]; then
	exit 0
fi

cat >tmp.desktop <<EOF
[Desktop Entry]
Name=Qtile (Wayland)
Comment=Qtile Session
Exec=qtile start -b wayland
Type=Application
Keywords=wm;tiling
EOF
sudo mv tmp.desktop /usr/share/wayland-sessions/qtile-wayland.desktop
