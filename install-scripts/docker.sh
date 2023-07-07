#!/usr/bin/env bash

version="4.21.1"

if [ -n "$1" ]; then
	version="$1"
fi

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

wget "https://desktop.docker.com/linux/main/amd64/docker-desktop-$version-amd64.deb" -O /tmp/docker-desktop.deb
sudo apt-get update
sudo apt-get install -y /tmp/docker-desktop.deb
rm /tmp/docker-desktop.deb
