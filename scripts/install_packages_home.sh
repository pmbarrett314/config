#!/bin/sh
# install_packages_home.sh — install dotfiles into ~/.local/bin
# as fallback for no package manager or no root
#
# Prebuilt release binaries are fetched with eget
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

# --- bootstrap eget --------------------------------------------------------
eget_bin=""
if command -v eget >/dev/null 2>&1; then
	eget_bin=$(command -v eget)
elif [ -x "$BIN/eget" ]; then
	eget_bin="$BIN/eget"
else
	echo "  bootstrapping eget..."
	_tmp=$(mktemp -d)
	if (cd "$_tmp" && curl -fsSL https://zyedidia.github.io/eget.sh | sh) >/dev/null 2>&1 && [ -x "$_tmp/eget" ]; then
		mv "$_tmp/eget" "$BIN/eget"
		eget_bin="$BIN/eget"
		echo "  eget -> $BIN/eget"
	else
		echo "  could not bootstrap eget — see https://github.com/zyedidia/eget"
	fi
	rm -rf "$_tmp"
fi

# --- fetch prebuilt binaries ----------------------------------------------
# fetch NAME OWNER/REPO — install ~/.local/bin/NAME via eget
# skip if already present
fetch() {
	if command -v "$1" >/dev/null 2>&1; then
		echo "  ok       $1 (already present)"
		return 0
	fi
	if [ -z "$eget_bin" ]; then
		echo "  SKIP     $1 (no eget)"
		return 1
	fi
	if "$eget_bin" --to "$BIN/$1" "$2" >/dev/null 2>&1; then
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
