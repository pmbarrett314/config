#!/bin/sh
set -eu

echo "--> Installing"
echo "--> Locating directory"
PERSONAL_CONFIG_DIR="$(
	unset CDPATH
	cd -- "$(dirname -- "$0")" >/dev/null 2>&1 && pwd -P
)"
export PERSONAL_CONFIG_DIR

# The default.* stubs hardcode $HOME/code/config. Warn if we live elsewhere.
if [ "$PERSONAL_CONFIG_DIR" != "$HOME/code/config" ]; then
	echo "WARNING: repo is at $PERSONAL_CONFIG_DIR but the stubs assume"
	echo "         \$HOME/code/config — clone there, or edit the default.* stubs."
fi

echo "--> dotfiles install — $PERSONAL_CONFIG_DIR"

# --- helpers ---------------------------------------------------------------
# link SRC DEST — symlink DEST -> SRC.
# Back up real files with timestamps if they exist.
# Crash if we can't find them, we're running against this repo.
link() {
	_src=$1
	_dest=$2
	if [ ! -e "$_src" ]; then
		echo "  ERROR   source $_src missing" >&2
		return 1
	fi
	if [ -L "$_dest" ]; then
		if [ "$(readlink "$_dest")" = "$_src" ]; then
			echo "  ok      $_dest"
			return 0
		fi
	elif [ -e "$_dest" ]; then
		_bak="$_dest.bak.$(date +%Y%m%d%H%M%S)"
		mv "$_dest" "$_bak"
		echo "  backup  $_dest -> $_bak"
	fi
	ln -sfn "$_src" "$_dest"
	echo "  link    $_dest -> $_src"
}

# copy_if_absent SRC DEST
# For files that can't just be links so we don't delete them.
# Also crash if file not found.
copy_if_absent() {
	if [ ! -e "$1" ]; then
		echo "  ERROR   source $1 missing" >&2
		return 1
	fi
	if [ -e "$2" ] || [ -L "$2" ]; then
		echo "  keep    $2 (already present)"
	else
		cp "$1" "$2"
		echo "  copy    $2 <- $1"
	fi
}

#these are just links so they update when the repo is pulled
echo "--> shell / editor stubs"
link "$PERSONAL_CONFIG_DIR/sh/default.profile" "$HOME/.profile"
link "$PERSONAL_CONFIG_DIR/bash/default.bashrc" "$HOME/.bashrc"
link "$PERSONAL_CONFIG_DIR/bash/default.bash_profile" "$HOME/.bash_profile"
link "$PERSONAL_CONFIG_DIR/zsh/default.zshenv" "$HOME/.zshenv"
link "$PERSONAL_CONFIG_DIR/vim/default.vimrc" "$HOME/.vimrc"

#these are copied, update per machine if needed
echo "--> per-machine files"
copy_if_absent "$PERSONAL_CONFIG_DIR/git/default.gitconfig" "$HOME/.gitconfig"
copy_if_absent "$PERSONAL_CONFIG_DIR/tmux/default.tmux.conf" "$HOME/.tmux.conf"

if command -v nano >/dev/null 2>&1 && command -v curl >/dev/null 2>&1; then
	echo "--> nano syntax highlighting"
	curl -fsSL https://raw.githubusercontent.com/galenguyer/nano-syntax-highlighting/master/install.sh |
		bash || echo "  WARNING: nano highlighting install failed"
fi

# --- runtime dirs + plugin manager clones ----------------------------------
echo "--> caches + state dirs"
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$HOME/.vim/undo"
mkdir -p "$HOME/.local/bin"

if command -v git >/dev/null 2>&1; then
	echo "--> antidote (zsh plugin manager)"
	_antidote_home="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"
	if [ ! -d "$_antidote_home/.git" ]; then
		git clone --depth 1 https://github.com/mattmc3/antidote "$_antidote_home" ||
			echo "  WARNING: antidote clone failed"
	else
		echo "  ok      antidote already cloned"
	fi
	unset _antidote_home
fi

# --- packages --------------------------------------------------------------
if [ -x "$PERSONAL_CONFIG_DIR/scripts/install_packages.sh" ]; then
	"$PERSONAL_CONFIG_DIR/scripts/install_packages.sh" "$@" || echo "  WARNING: package install reported errors"
else
	echo "--> packages skipped — scripts/install_packages.sh not found"
fi

PATH="$HOME/.local/bin:$PATH"
echo "--> tpack plugins."
if command -v tpack >/dev/null 2>&1; then
	tpack install || echo "  WARNING: tpack install failed"
else
	echo "  WARNING: tpack not found on PATH — plugins not installed"
fi

# --- done ------------------------------------------------------------------
echo
echo "--> done — open a new shell."
echo "    vim:  launch once for vim-plug, then :LspInstallServer in a buffer."
echo "    tmux: start a session; tpack will set up declared plugins."
