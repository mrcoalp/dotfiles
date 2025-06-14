if status is-interactive
	# Commands to run in interactive sessions can go here
end

# Environment
set -x fish_greeting
set -x FZF_DEFAULT_COMMAND "rg --follow --files --hidden"
set -x PYENV_ROOT "$HOME/.pyenv"
set -x GOROOT "$HOME/go"
set -x GOPATH "$HOME/go/packages"
set -x BUN_INSTALL "$HOME/.bun"
set -x ZIG_INSTALL "$HOME/.zig"

# Extra components on $PATH
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.flutter/bin"
fish_add_path "$GOROOT/bin"
fish_add_path "$GOPATH/bin"
fish_add_path "$BUN_INSTALL/bin"
fish_add_path "$ZIG_INSTALL"
fish_add_path "$(python3 -m site --user-base)/bin"

if test -d "$PYENV_ROOT/bin"
	fish_add_path "$PYENV_ROOT/bin"
	pyenv init - | source
end

# Aliases
alias ls='lsd --group-dirs first'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias gfr='git pull --rebase --autostash'
alias gco='git checkout'

# Functions
function _info -d "print info about the current system"
	echo "OS: $(lsb_release -d | cut -f2)"
	echo "Shell: $SHELL"
	echo "Fish: $FISH_VERSION"
	echo "Hostname: $(hostname)"
	echo "User: $USER"
	echo "Home: $HOME"
	echo "Path: $PATH"
	echo "Editor: $EDITOR"
	echo "Terminal: $TERM"
	echo "TTY: $(tty)"
	echo "CPU: $(uname -p)"
	echo "Arch: $(uname -m)"
	echo "Kernel: $(uname -r)"
	echo "Uptime: $(uptime)"
	echo
	echo "$(free -h)"
	echo
	echo "$(df -h /)"
end

function update -d "update system"
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get dist-upgrade -y
	sudo apt-get autoremove -y
	sudo apt-get autoclean -y
end

function zx -d "cd into folder using z and start new tmux session"
	if test -z "$argv"
		echo "Usage: zx <folder>"
		return 1
	end

	if ! z "$argv"
		return 1
	end

	tmux new -s "$argv"
end
