#!/bin/sh
# install_packages_home.sh — install dotfiles into ~/.local/bin
# as fallback for no package manager or no root
#
# Prebuilt release binaries are fetched with ubi
# tmux-mem-cpu load not included because it needs a build and I probably don't need it on non-root machines anyways
# git, tmux, vim, nano, zsh not included because we assume they'll be there and if not I probably can't install them well

set -u

BIN="$HOME/.local/bin"

echo "--> home install — $BIN"

if ! command -v curl >/dev/null 2>&1; then
	echo "  curl is required and not available — cannot continue"
	exit 1
fi
mkdir -p "$BIN"

# --- bootstrap ubi ---------------------------------------------------------
ubi_bin=""
if command -v ubi >/dev/null 2>&1; then
	ubi_bin=$(command -v ubi)
elif [ -x "$BIN/ubi" ]; then
	ubi_bin="$BIN/ubi"
else
	echo "  bootstrapping ubi..."
	if curl --silent --location \
		https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh |
		TARGET="$BIN" sh; then
		[ -x "$BIN/ubi" ] && ubi_bin="$BIN/ubi" && echo "  ubi -> $BIN/ubi"
	fi
	[ -z "$ubi_bin" ] && echo "  could not bootstrap ubi — see https://github.com/houseabsolute/ubi"
fi

# --- fetch prebuilt binaries ----------------------------------------------
# fetch BINNAME OWNER/REPO — install ~/.local/bin/BINNAME via ubi
# skip if already present;
fetch() {
	if command -v "$1" >/dev/null 2>&1; then
		echo "  ok       $1 (already present)"
		return 0
	fi
	if [ -z "$ubi_bin" ]; then
		echo "  SKIP     $1 (no ubi)"
		return 1
	fi
	if "$ubi_bin" --project "$2" --in "$BIN" --exe "$1"; then
		echo "  got      $1 <- $2"
	else
		echo "  FAILED   $1 <- $2"
		return 1
	fi
}

_failed=""
fetch starship  starship/starship       || _failed="$_failed starship"
fetch zoxide    ajeetdsouza/zoxide      || _failed="$_failed zoxide"
fetch atuin     atuinsh/atuin           || _failed="$_failed atuin"
fetch fzf       junegunn/fzf            || _failed="$_failed fzf"
fetch fd        sharkdp/fd              || _failed="$_failed fd"
fetch bat       sharkdp/bat             || _failed="$_failed bat"
fetch rg        BurntSushi/ripgrep      || _failed="$_failed rg"
fetch eza       eza-community/eza       || _failed="$_failed eza"
fetch delta     dandavison/delta        || _failed="$_failed delta"
fetch lazygit   jesseduffield/lazygit   || _failed="$_failed lazygit"
fetch gh        cli/cli                 || _failed="$_failed gh"
fetch tldr      tealdeer-rs/tealdeer    || _failed="$_failed tldr"
fetch navi      denisidoro/navi         || _failed="$_failed navi"
fetch direnv    direnv/direnv           || _failed="$_failed direnv"
fetch fastfetch fastfetch-cli/fastfetch || _failed="$_failed fastfetch"
fetch tpack     tmuxpack/tpack          || _failed="$_failed tpack"

[ -n "$_failed" ] && echo "  could not install:$_failed"

echo "--> home install done — open a new shell so ~/.local/bin is on PATH"
