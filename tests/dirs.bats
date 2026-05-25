#!/usr/bin/env bats
# Dirs and symlinks — what install.sh should leave behind in $HOME.

load 'test_helper/common'

setup_file() {
	load_dotfiles_env
}

# --- symlinks pointing back at the repo ---

@test "~/.profile -> repo stub" {
	[ -L "$HOME/.profile" ]
	[ "$(readlink "$HOME/.profile")" = "$REPO_ROOT/sh/default.profile" ]
}

@test "~/.bashrc -> repo stub" {
	[ -L "$HOME/.bashrc" ]
	[ "$(readlink "$HOME/.bashrc")" = "$REPO_ROOT/bash/default.bashrc" ]
}

@test "~/.bash_profile -> repo stub" {
	[ -L "$HOME/.bash_profile" ]
	[ "$(readlink "$HOME/.bash_profile")" = "$REPO_ROOT/bash/default.bash_profile" ]
}

@test "~/.zshenv -> repo stub" {
	[ -L "$HOME/.zshenv" ]
	[ "$(readlink "$HOME/.zshenv")" = "$REPO_ROOT/zsh/default.zshenv" ]
}

@test "~/.vimrc -> repo stub" {
	[ -L "$HOME/.vimrc" ]
	[ "$(readlink "$HOME/.vimrc")" = "$REPO_ROOT/vim/default.vimrc" ]
}

# --- per-machine files copied (not linked) ---

@test "~/.gitconfig exists" {
	[ -f "$HOME/.gitconfig" ]
}

@test "~/.tmux.conf exists" {
	[ -f "$HOME/.tmux.conf" ]
}

# --- dirs install.sh / install_packages_home.sh create ---

@test "zsh cache dir exists" {
	cache="${XDG_CACHE_HOME:-$HOME/.cache}"
	[ -d "$cache/zsh" ]
}

@test "vim undo dir exists" {
	[ -d "$HOME/.vim/undo" ]
}

@test "~/.local/bin exists" {
	[ -d "$HOME/.local/bin" ]
}

@test "antidote cloned" {
	data="${XDG_DATA_HOME:-$HOME/.local/share}"
	[ -d "$data/antidote/.git" ]
}

# --- tmux plugins (tpack runs in install.sh after the PM step) ---

@test "tpack plugin dir exists" {
	command -v tpack >/dev/null 2>&1 || skip "tpack not installed"
	[ -d "$HOME/.tmux/plugins" ]
}

@test "tpack installed a declared plugin (tmux-power)" {
	command -v tpack >/dev/null 2>&1 || skip "tpack not installed"
	[ -d "$HOME/.tmux/plugins/tmux-power" ]
}
