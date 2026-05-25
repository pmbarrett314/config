#!/bin/sh
# scripts/ubi.sh — ubi bootstrap + project map. Not meant to be run on its own.
#
# Used by:
#   scripts/install_packages.sh      — per-package fallback when system PM
#                                      doesn't provide the binary
#   scripts/install_packages_home.sh — bulk install when no PM is available

UBI_DEST="${UBI_DEST:-$HOME/.local/bin}"
UBI_BIN="${UBI_BIN:-}"

# ubi_bootstrap — ensure $UBI_BIN points at an executable ubi.
# Returns 1 if bootstrap fails.
ubi_bootstrap() {
	if [ -n "$UBI_BIN" ] && [ -x "$UBI_BIN" ]; then
		return 0
	fi
	if command -v ubi >/dev/null 2>&1; then
		UBI_BIN=$(command -v ubi)
		return 0
	fi
	if [ -x "$UBI_DEST/ubi" ]; then
		UBI_BIN="$UBI_DEST/ubi"
		return 0
	fi
	if ! command -v curl >/dev/null 2>&1; then
		echo "  ubi: curl missing — cannot bootstrap" >&2
		return 1
	fi
	mkdir -p "$UBI_DEST"
	echo "  bootstrapping ubi -> $UBI_DEST"
	if curl --silent --location \
		https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh |
		TARGET="$UBI_DEST" sh; then
		if [ -x "$UBI_DEST/ubi" ]; then
			UBI_BIN="$UBI_DEST/ubi"
			return 0
		fi
	fi
	echo "  ubi: bootstrap failed" >&2
	return 1
}

# ubi_project BINNAME — print OWNER/REPO for ubi, empty if no known mapping.
ubi_project() {
	case "$1" in
	starship) echo starship/starship ;;
	zoxide) echo ajeetdsouza/zoxide ;;
	fzf) echo junegunn/fzf ;;
	fd) echo sharkdp/fd ;;
	bat) echo sharkdp/bat ;;
	rg) echo BurntSushi/ripgrep ;;
	eza) echo eza-community/eza ;;
	delta) echo dandavison/delta ;;
	lazygit) echo jesseduffield/lazygit ;;
	gh) echo cli/cli ;;
	tldr) echo tealdeer-rs/tealdeer ;;
	navi) echo denisidoro/navi ;;
	direnv) echo direnv/direnv ;;
	fastfetch) echo fastfetch-cli/fastfetch ;;
	tpack) echo tmuxpack/tpack ;;
	esac
}

# UBI_BINS — every binary ubi_project knows about. Used by the bulk
# installer (install_packages_home.sh). Keep in sync with ubi_project.
UBI_BINS="starship zoxide fzf fd bat rg eza delta lazygit gh tldr navi direnv fastfetch tpack"

export UBI_BINS

# ubi_fetch BINNAME PROJECT — install BINNAME from GH PROJECT into $UBI_DEST.
# Returns 1 on bootstrap or install failure.
ubi_fetch() {
	if ! ubi_bootstrap; then
		return 1
	fi
	"$UBI_BIN" --project "$2" --in "$UBI_DEST" --exe "$1"
}
