#!/usr/bin/env bash

if which pyenv >/dev/null; then
	echo "PyEnv already installed"
	exit 1
fi

which curl >/dev/null || sudo apt install -y curl
curl https://pyenv.run | bash
