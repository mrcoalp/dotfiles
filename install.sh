#!/usr/bin/env bash

log_info() {
	echo -e "\e[1;36m$1\e[0m"
}

log_success() {
	echo -e "\e[1;32m$1\e[0m"
}

log_warning() {
	echo -e "\e[1;33m$1\e[0m"
}

log_error() {
	echo -e "\e[1;31m$1\e[0m"
}

if [ ! "$(awk -F= '/^NAME/{print $2}' /etc/os-release)" = "\"Ubuntu\"" ]; then
	log_error "Only Ubuntu is supported"
	exit 1
fi

function ask() {
	read -r -p "$1 [y/N] " response
	if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
		return 1
	fi
	return 0
}

function file_exists() {
	if [ -f "$1" ] || [ -d "$1" ]; then
		return 0
	fi
	return 1
}

function install_ppas() {
	local ppas=$1

	for ppa in $ppas; do
		if ! grep -q "^deb .*$ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
			log_info "Adding PPA: $ppa"
			sudo add-apt-repository -y "ppa:$ppa"
		fi
	done

	sudo apt update
}

function install_deps() {
	local deps=$1

	for dep in $deps; do
		if ! which "$dep" >/dev/null; then
			log_info "Installing dependecy: $dep"
			sudo apt install -y "$dep"
		fi
	done
}

function create_links() {
	local file_list=$1
	local dest_folder=$2
	local script_dir=""

	script_dir="$(dirname "$(readlink -f "$0")")"

	for file in $file_list; do
		if file_exists "$dest_folder/$file"; then
			if ! ask "Entry $file already exists. Reinstall?"; then
				continue
			fi

			rm -rf "${dest_folder:?}/$file"
		fi

		log_info "Linking $script_dir/$file to $dest_folder/$file"
		ln -sf "$script_dir/$file" "$dest_folder/$file"
	done
}

function install_fonts() {
	local fonts=$1

	mkdir -p "$HOME/.fonts"

	for font in $fonts; do
		if file_exists "$HOME/.fonts/$font"; then
			if ! ask "Font $font already exists. Reinstall?"; then
				continue
			fi

			rm -rf "$HOME/.fonts/$font"
		fi

		log_info "Installing font $font"
		# wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip" -O "/tmp/$font.zip"
		wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/$font.zip" -O "/tmp/$font.zip"
		unzip "/tmp/$font.zip" -d "$HOME/.fonts/$font"
		rm "$HOME"/.fonts/"$font"/*Windows*
		rm "/tmp/$font.zip"
	done
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# fetch themes
bash "$script_dir/fetch_themes.sh"

# create config folder if it doesn't exist
mkdir -p "$HOME/.config"

# linked config files
create_links "alacritty fish i3 lazygit nvim tmux" "$HOME/.config"

# add ppas
install_ppas "aslatter/ppa fish-shell/release-3"

# install dependencies
install_deps "python3-pip python3-venv"
install_deps "alacritty autoconf build-essential fish flameshot"
install_deps "p7zip-full pavucontrol tmux thunar"
install_deps "ninja-build gettext unzip curl"
install_deps "brightnessctl dex dunst feh i3 i3lock i3status"
install_deps "lxpolkit rofi xss-lock"

# download and install fonts
install_fonts "JetBrainsMono Ubuntu" # "Hack FiraCode JetBrainsMono Meslo CascadiaCode"

# install tmux plugin manager
if [ ! -d tmux/plugins/tpm ]; then
	log_info "Installing tmux plugin manager"
	git clone --recursive https://github.com/tmux-plugins/tpm.git tmux/plugins/tpm
fi

log_info "Add '$USER' to 'video' group"
sudo usermod -a -G video "$USER"

log_info "Set alacritty as default terminal"
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$(which alacritty)" 99

# ========================
# start fish shell check
# ========================

if [ ! "$(basename "$SHELL")" = "fish" ]; then
	log_info "Run '$(which fish)' to start fish shell"
	log_info "Run 'chsh -s $(which fish)' to change your shell to fish, permanently"
	log_error "To continue you need to change your shell to fish"
	exit 1
fi

if ! fish -c "fisher --version" >/dev/null; then
	log_error "Required plugins for fish shell are not installed"
	log_info "Run 'fish $script_dir/install-scripts/fisher.sh' to install fisher"
	exit 1
fi

# ========================
# end fish shell check
# ========================

# install cargo
if ! which cargo >/dev/null || ask "cargo already installed. Reinstall?"; then
	log_info "Installing cargo"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# install go
if ! which go >/dev/null || ask "go already installed. Reinstall?"; then
	log_info "Installing go"
	wget "https://go.dev/dl/go1.21.5.linux-amd64.tar.gz" -O /tmp/go.tar.gz
	rm -rf "$HOME/go"
	tar -xvf /tmp/go.tar.gz -C "$HOME"
	rm -rf /tmp/go.tar.gz
fi

# install lsd
if ! which lsd >/dev/null || ask "lsd already installed. Reinstall?"; then
	log_info "Installing LSDeluxe"
	wget "https://github.com/lsd-rs/lsd/releases/download/v1.0.0/lsd-musl_1.0.0_amd64.deb" -O /tmp/lsd.deb
	sudo dpkg -i /tmp/lsd.deb
	rm /tmp/lsd.deb
fi

# install fd-find
if ! which fd >/dev/null || ask "fd already installed. Reinstall?"; then
	log_info "Installing fd-find"
	wget "https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-musl_9.0.0_amd64.deb" -O /tmp/fd.deb
	sudo dpkg -i /tmp/fd.deb
	rm /tmp/fd.deb
fi

# install ripgrep
if ! which rg >/dev/null || ask "rg already installed. Reinstall?"; then
	log_info "Installing ripgrep"
	wget "https://github.com/BurntSushi/ripgrep/releases/download/14.0.3/ripgrep_14.0.3-1_amd64.deb" -O /tmp/ripgrep.deb
	sudo dpkg -i /tmp/ripgrep.deb
	rm /tmp/ripgrep.deb
fi

# install bat
if ! which bat >/dev/null || ask "bat already installed. Reinstall?"; then
	log_info "Installing bat"
	wget "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-musl_0.24.0_amd64.deb" -O /tmp/bat.deb
	sudo dpkg -i /tmp/bat.deb
	rm /tmp/bat.deb
fi

# install fzf
if ! which fzf >/dev/null || ask "fzf already installed. Reinstall?"; then
	log_info "Installing fzf"
	wget "https://github.com/junegunn/fzf/releases/download/0.44.1/fzf-0.44.1-linux_amd64.tar.gz" -O /tmp/fzf.tar.gz
	sudo tar -xvf /tmp/fzf.tar.gz -C /usr/local/bin
	rm /tmp/fzf.tar.gz
fi

# install delta
if ! which delta >/dev/null || ask "delta already installed. Reinstall?"; then
	log_info "Installing delta"
	wget "https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb" -O /tmp/git-delta.deb
	sudo dpkg -i /tmp/git-delta.deb
	rm -rf /tmp/git-delta.deb
fi

# install cmake
if ! which cmake >/dev/null || ask "cmake already installed. Reinstall?"; then
	log_info "Installing cmake"
	wget "https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1-linux-x86_64.sh" -O /tmp/cmake.sh
	sudo sh /tmp/cmake.sh --prefix=/usr/local/ --exclude-subdir --skip-licenses
	rm /tmp/cmake.sh
fi

# install neovim
if ! which nvim >/dev/null || ask "nvim already installed. Reinstall?"; then
	log_info "Installing neovim"
	git clone --recursive --depth 1 -b stable https://github.com/neovim/neovim.git /tmp/neovim
	cd /tmp/neovim || exit 1
	make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME/.local" -j"$(nproc)"
	make install
	rm -rf /tmp/neovim
	cd - || exit 1
fi

# install spotify client
if ! which spotify >/dev/null; then
	log_info "Installing spotify client"
	curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-get update && sudo apt-get --yes install spotify-client
fi

# install lazygit
if ! which lazygit >/dev/null || ask "lazygit already installed. Reinstall?"; then
	log_info "Installing lazygit"
	go install github.com/jesseduffield/lazygit@latest
fi

which npm >/dev/null || log_warning "npm not found, but required"

log_success "All done!"

exit 0
