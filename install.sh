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

log_critical() {
	log_error "$1"
	exit 1
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
		log_info "Installing dependecy: $dep"
		sudo apt install -y "$dep"
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

# create config folder if it doesn't exist
mkdir -p "$HOME/.config"

# linked config files
create_links "fish lazygit nvim tmux" "$HOME/.config"

# add ppas
install_ppas "fish-shell/release-3"

# install dependencies
install_deps "python3-pip python3-venv"
install_deps "build-essential fish"
install_deps "p7zip-full tmux"
install_deps "ninja-build gettext unzip curl"

if ask "Install fonts?"; then
	# download and install fonts
	install_fonts "JetBrainsMono Ubuntu"
fi

# fetch themes
bash "$script_dir/fetch_themes.sh"

# install tmux plugin manager
if [ ! -d tmux/plugins/tpm ]; then
	log_info "Installing tmux plugin manager"
	git clone --recursive https://github.com/tmux-plugins/tpm.git tmux/plugins/tpm
fi

if ask "Install alacritty?"; then
	log_info "Installing alacritty"
	create_links "alacritty" "$HOME/.config"

	install_ppas "aslatter/ppa"
	install_deps "alacritty"

	log_info "Set alacritty as default terminal"
	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$(which alacritty)" 99
fi

if ask "Install pavucontrol?"; then
	log_info "Installing pavucontrol"
	install_deps "pavucontrol"
fi

if ask "Install feh?"; then
	log_info "Installing feh"
	install_deps "feh"
fi

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
if ask "Install cargo?"; then
	log_info "Installing cargo"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# install go
if ask "Install go?"; then
	go_version="1.23.2"
	log_info "Installing go"
	wget "https://go.dev/dl/go${go_version}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
	sudo rm -rf "$HOME/go" || log_critical "Failed to remove go directory"
	tar -xvf /tmp/go.tar.gz -C "$HOME" || log_critical "Failed to extract go tarball"
	rm -rf /tmp/go.tar.gz
fi

# install lsd
if ask "Install lsd?"; then
	lsd_version="1.1.5"
	log_info "Installing LSDeluxe"
	wget "https://github.com/lsd-rs/lsd/releases/download/v${lsd_version}/lsd-musl_${lsd_version}_amd64.deb" -O /tmp/lsd.deb
	sudo dpkg -i /tmp/lsd.deb || log_critical "Failed to install lsd"
	rm /tmp/lsd.deb
fi

# install fd-find
if ask "Install fd?"; then
	fd_version="10.2.0"
	log_info "Installing fd-find"
	wget "https://github.com/sharkdp/fd/releases/download/v${fd_version}/fd-musl_${fd_version}_amd64.deb" -O /tmp/fd.deb
	sudo dpkg -i /tmp/fd.deb || log_critical "Failed to install fd"
	rm /tmp/fd.deb
fi

# install ripgrep
if ask "Install rg?"; then
	rg_version="14.1.1"
	log_info "Installing ripgrep"
	wget "https://github.com/BurntSushi/ripgrep/releases/download/${rg_version}/ripgrep_${rg_version}-1_amd64.deb" -O /tmp/ripgrep.deb
	sudo dpkg -i /tmp/ripgrep.deb || log_critical "Failed to install rg"
	rm /tmp/ripgrep.deb
fi

# install bat
if ask "Install bat?"; then
	bat_version="0.24.0"
	log_info "Installing bat"
	wget "https://github.com/sharkdp/bat/releases/download/v${bat_version}/bat-musl_${bat_version}_amd64.deb" -O /tmp/bat.deb
	sudo dpkg -i /tmp/bat.deb || log_critical "Failed to install bat"
	rm /tmp/bat.deb
fi

# install fzf
if ask "Install fzf?"; then
	fzf_version="0.56.0"
	log_info "Installing fzf"
	wget "https://github.com/junegunn/fzf/releases/download/v${fzf_version}/fzf-${fzf_version}-linux_amd64.tar.gz" -O /tmp/fzf.tar.gz
	sudo tar -xvf /tmp/fzf.tar.gz -C /usr/local/bin || log_critical "Failed to install fzf"
	rm /tmp/fzf.tar.gz
fi

# install delta
if ask "Install delta?"; then
	delta_version="0.18.2"
	log_info "Installing delta"
	wget "https://github.com/dandavison/delta/releases/download/${delta_version}/git-delta_${delta_version}_amd64.deb" -O /tmp/git-delta.deb
	sudo dpkg -i /tmp/git-delta.deb || log_critical "Failed to install delta"
	rm -rf /tmp/git-delta.deb
fi

# install cmake
if ask "Install cmake?"; then
	cmake_version="3.30.5"
	log_info "Installing cmake"
	wget "https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}-linux-x86_64.sh" -O /tmp/cmake.sh
	sudo sh /tmp/cmake.sh --prefix=/usr/local/ --exclude-subdir --skip-licenses
	rm /tmp/cmake.sh
fi

# install neovim
if ask "Install nvim?"; then
	log_info "Installing neovim"
	git clone --recursive --depth 1 -b stable https://github.com/neovim/neovim.git /tmp/neovim
	cd /tmp/neovim || exit 1
	make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME/.local" -j"$(nproc)"
	make install
	rm -rf /tmp/neovim
	cd - || exit 1
fi

# install luarocks
if ask "Install luarocks?"; then
	log_info "Installing luarocks"
	install_deps "luarocks"
fi

# install spotify client
if ask "Install spotify?"; then
	log_info "Installing spotify client"
	curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-get update && sudo apt-get --yes install spotify-client
fi

# install lazygit
if ask "Install lazygit?"; then
	log_info "Installing lazygit"
	go install github.com/jesseduffield/lazygit@latest
fi

which npm >/dev/null || log_warning "npm not found, but required"

log_success "All done!"

exit 0
