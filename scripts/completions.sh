#!/bin/sh
# scripts/completions.sh — zsh completions for binaries fetched as bare
# executables. Not meant to be run on its own.
#
# Used by:
#   scripts/install_packages.sh      — after the pkgs/macos-x86_64.txt loop
#
# A system package installs its completion under
# ${prefix}/share/zsh/site-functions, which is on fpath. ubi and cargo install
# one file, the executable, so moving a tool to those lanes silently drops its
# completion. Most of these tools can print their own on demand; the rest keep
# it in their repo, in a separate release asset, or inside the package itself.
#
# $COMP_DEST is on fpath already (see zsh/.zshrc). Files are named _<bin>
# because that is what the zsh completion system looks for.

COMP_DEST="${COMP_DEST:-$HOME/.zfunc}"

# comp_cmd BINNAME — print a command that writes a zsh completion to stdout,
# empty when the binary has no generator. The spellings are all different.
comp_cmd() {
	case "$1" in
	bat) echo "bat --completion zsh" ;;
	fd) echo "fd --gen-completions zsh" ;;
	rg) echo "rg --generate complete-zsh" ;;
	starship) echo "starship completions zsh" ;;
	gh) echo "gh completion -s zsh" ;;
	glow) echo "glow completion zsh" ;;
	lazygit) echo "lazygit completion zsh" ;;
	git-flow) echo "git-flow completion zsh" ;;
	rclone) echo "rclone completion zsh -" ;;
	act) echo "act completion zsh" ;;
	esac
}

# comp_url BINNAME VERSION — print a URL serving a ready-made completion for
# the three with no generator, empty otherwise. VERSION is the bare version
# string; these repos tag with a leading v.
comp_url() {
	case "$1" in
	zoxide) echo "https://raw.githubusercontent.com/ajeetdsouza/zoxide/v$2/contrib/completions/_zoxide" ;;
	tldr) echo "https://raw.githubusercontent.com/tealdeer-rs/tealdeer/v$2/completion/zsh_tealdeer" ;;
	# eza ships completions as their own release asset rather than in-tree.
	eza) echo "https://github.com/eza-community/eza/releases/download/v$2/completions-$2.tar.gz" ;;
	# fastfetch has no generator flag, and its tags carry no leading v. The
	# in-tree file is byte-for-byte the _fastfetch Homebrew installed.
	fastfetch) echo "https://raw.githubusercontent.com/fastfetch-cli/fastfetch/$2/completions/fastfetch.zsh" ;;
	esac
}

# comp_file BINNAME — print a path to a completion already on disk inside the
# package that provided BINNAME, empty otherwise. For a gem there is no URL
# worth hard-coding and no generator: the file ships in the gem, so ask
# RubyGems where it put it and the version matches the binary by construction.
# Homebrew's tmuxinator-completion formula was this same file, byte for byte.
comp_file() {
	case "$1" in
	tmuxinator)
		command -v gem >/dev/null 2>&1 || return 0
		gem contents tmuxinator 2>/dev/null |
			grep -E '/completion/tmuxinator\.zsh$' | head -1
		;;
	esac
}

# comp_version BINNAME — the installed version, bare (no leading v).
# Scans the whole output rather than the first line: eza puts its tagline
# on line 1 and the version on line 2.
comp_version() {
	"$1" --version 2>/dev/null |
		grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1
}

# comp_install BINNAME — write $COMP_DEST/_BINNAME. Returns 1 if it could not.
comp_install() {
	command -v "$1" >/dev/null 2>&1 || return 1
	mkdir -p "$COMP_DEST" || return 1
	_dst="$COMP_DEST/_$1"
	_cmd=$(comp_cmd "$1")

	if [ -n "$_cmd" ]; then
		# Generated in an empty directory and an empty HOME. These scripts
		# are static, so a clean environment costs nothing — and act needs
		# one: it reads .actrc from both the working directory and $HOME
		# and parses it as root flags before it reaches the subcommand, so
		# `act completion zsh` fails anywhere a .actrc exists.
		_tmp=$(mktemp -d) || return 1
		# Word splitting is the point — $_cmd is a command line.
		# shellcheck disable=SC2086
		if (cd "$_tmp" && HOME="$_tmp" eval $_cmd) >"$_dst.new" 2>/dev/null &&
			[ -s "$_dst.new" ]; then
			mv "$_dst.new" "$_dst"
			rm -rf "$_tmp"
			unset _dst _cmd _tmp
			return 0
		fi
		rm -f "$_dst.new"
		rm -rf "$_tmp"
		unset _dst _cmd _tmp
		return 1
	fi

	_file=$(comp_file "$1")
	if [ -n "$_file" ] && [ -r "$_file" ]; then
		if cp "$_file" "$_dst"; then
			unset _dst _cmd _file
			return 0
		fi
		unset _dst _cmd _file
		return 1
	fi

	_ver=$(comp_version "$1")
	_url=$(comp_url "$1" "$_ver")
	if [ -z "$_ver" ] || [ -z "$_url" ]; then
		unset _dst _cmd _file _ver _url
		return 1
	fi
	command -v curl >/dev/null 2>&1 || return 1
	case "$_url" in
	*.tar.gz)
		_tmp=$(mktemp -d) || return 1
		if curl -fsSL "$_url" -o "$_tmp/c.tar.gz" &&
			tar -xzf "$_tmp/c.tar.gz" -C "$_tmp" &&
			_found=$(find "$_tmp" -name "_$1" -type f | head -1) &&
			[ -n "$_found" ]; then
			cp "$_found" "$_dst"
			rm -rf "$_tmp"
			unset _dst _cmd _ver _url _tmp _found
			return 0
		fi
		rm -rf "$_tmp"
		unset _dst _cmd _ver _url _tmp _found
		return 1
		;;
	*)
		if curl -fsSL "$_url" -o "$_dst.new" && [ -s "$_dst.new" ]; then
			mv "$_dst.new" "$_dst"
			unset _dst _cmd _ver _url
			return 0
		fi
		rm -f "$_dst.new"
		unset _dst _cmd _ver _url
		return 1
		;;
	esac
}

# COMP_BINS — binaries worth a completion file. Omitted on purpose: fzf
# (shipped by `fzf --zsh`), direnv, duf, shfmt, yamlfmt, presenterm and navi,
# none of which has a zsh completion upstream or from a system package.
COMP_BINS="bat fd rg starship gh glow lazygit git-flow rclone act zoxide tldr eza tmuxinator fastfetch"

# comp_install_all — install every COMP_BINS completion that is installable.
comp_install_all() {
	for _b in $COMP_BINS; do
		if comp_install "$_b"; then
			echo "  comp     _$_b"
		elif command -v "$_b" >/dev/null 2>&1; then
			echo "  no comp  $_b"
		fi
	done
	unset _b
}
