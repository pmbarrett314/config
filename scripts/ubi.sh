#!/bin/sh
# scripts/ubi.sh — ubi bootstrap + project map. Not meant to be run on its own.
#
# Used by:
#   scripts/install_packages.sh      — per-package fallback when system PM
#                                      doesn't provide the binary
#   scripts/install_packages_home.sh — bulk install when no PM is available

UBI_DEST="${UBI_DEST:-$HOME/.local/bin}"
UBI_BIN="${UBI_BIN:-}"

# host_arch — CPU arch spelled the way release assets spell it. macOS reports
# arm64 where asset names say aarch64, hence the mapping.
host_arch() {
	case "$(uname -m)" in
	x86_64 | amd64) echo x86_64 ;;
	arm64 | aarch64) echo aarch64 ;;
	*) uname -m ;;
	esac
}

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
	# Below are reachable only through pkgs/macos-x86_64.txt. They are
	# deliberately absent from UBI_BINS so the home installer's set is
	# unchanged — see the note on UBI_BINS.
	uv) echo astral-sh/uv ;;
	pixi) echo prefix-dev/pixi ;;
	prek) echo j178/prek ;;
	difft) echo Wilfred/difftastic ;;
	atuin) echo atuinsh/atuin ;;
	pandoc) echo jgm/pandoc ;;
	shellcheck) echo koalaman/shellcheck ;;
	act) echo nektos/act ;;
	duf) echo muesli/duf ;;
	glow) echo charmbracelet/glow ;;
	presenterm) echo mfontanini/presenterm ;;
	rclone) echo rclone/rclone ;;
	shfmt) echo mvdan/sh ;;
	yamlfmt) echo google/yamlfmt ;;
	git-flow) echo gittower/git-flow-next ;;
	esac
}

# ubi_matching BINNAME — optional asset substring filter, empty for most
# projects. Only needed where one release ships several binaries for the
# same platform and ubi cannot tell which one we meant.
ubi_matching() {
	case "$1" in
	# Every atuin release carries both the client and atuin-server for
	# each platform; unfiltered, ubi can pick the server.
	atuin) echo "atuin-$(host_arch)" ;;
	esac
}

# UBI_BINS — the binaries the bulk installer (install_packages_home.sh)
# installs. This is an install set, not an index: ubi_project knows about
# more binaries than this on purpose, so adding a mapping there does not
# change what a no-package-manager machine installs.
UBI_BINS="starship zoxide fzf fd bat rg eza delta lazygit gh tldr navi direnv fastfetch tpack"

export UBI_BINS

# ubi_fetch BINNAME PROJECT — install BINNAME from GH PROJECT into $UBI_DEST.
# Returns 1 on bootstrap or install failure.
ubi_fetch() {
	if ! ubi_bootstrap; then
		return 1
	fi
	_match=$(ubi_matching "$1")
	if [ -n "$_match" ]; then
		"$UBI_BIN" --project "$2" --in "$UBI_DEST" --exe "$1" --matching "$_match"
	else
		"$UBI_BIN" --project "$2" --in "$UBI_DEST" --exe "$1"
	fi
	_rc=$?
	unset _match
	return $_rc
}
