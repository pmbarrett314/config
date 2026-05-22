#!/bin/sh
# install_packages.sh — install dotfile dependencies with system package manager
# On Linux, packages install one at a time: a name the manager doesn't have is
# reported at the end, not fatal — repo coverage varies by distro and release.

set -u

PERSONAL_CONFIG_DIR="${PERSONAL_CONFIG_DIR:-$(
	unset CDPATH
	cd -- "$(dirname -- "$0")/.." >/dev/null 2>&1 && pwd -P
)}"
PKGS="$PERSONAL_CONFIG_DIR/pkgs"
HOME_SCRIPT="$PERSONAL_CONFIG_DIR/scripts/install_packages_home.sh"

# run_home [force] — the gate for the home-directory install.
# If force is set don't confirm
# if force is not set, prompt if running interactively otherwise exit
# set --home on the script to set force
run_home() {
	if [ ! -x "$HOME_SCRIPT" ]; then
		echo "  no package manager available, and no $HOME_SCRIPT"
		exit 1
	fi
	if [ "${1:-}" != force ]; then
		_ans=""
		if [ -t 0 ]; then
			printf "  install tools into ~/.local/bin? [y] yes   [e] exit  [y/e] "
			read -r _ans
		fi
		case "$_ans" in
		[Yy]*) ;;
		*)
			echo "  exiting without installing"
			exit 0
			;;
		esac
	fi
	exec "$HOME_SCRIPT"
}

# `--home` forces the home-directory install even where a package manager exists.
[ "${1:-}" = "--home" ] && run_home force

# --- helpers ---------------------------------------------------------------

# as_root CMD... — run CMD as root: directly if already root, else via sudo.
as_root() {
	if [ "$(id -u)" -eq 0 ]; then
		"$@"
	else
		sudo "$@"
	fi
}

# install_list LABEL LIST_FILE INSTALL_CMD... — run INSTALL_CMD <pkg> for every
# non-comment line of LIST_FILE; collect and report the ones that fail.
install_list() {
	_label=$1
	_list=$2
	shift 2
	if [ ! -r "$_list" ]; then
		echo "  skipped — no list at $_list"
		return
	fi
	_failed=""
	while IFS= read -r _pkg || [ -n "$_pkg" ]; do
		case $_pkg in '' | \#*) continue ;; esac
		if "$@" "$_pkg" >/dev/null 2>&1; then
			echo "  ok       $_pkg"
		else
			echo "  FAILED   $_pkg"
			_failed="$_failed $_pkg"
		fi
	done <"$_list"
	if [ -n "$_failed" ]; then
		echo "  $_label has no package for:$_failed"
		echo "  (install those another way)"
	fi
}

# install_tpack — tmux plugin manager; not in standard repos on any platform.
install_tpack() {
	if command -v tpack >/dev/null 2>&1; then
		echo "  tpack already installed"
		return
	fi
	if command -v brew >/dev/null 2>&1; then
		brew install tmuxpack/tpack/tpack && return
	fi
	for _h in yay paru; do
		if command -v "$_h" >/dev/null 2>&1; then
			"$_h" -S --needed --noconfirm tpack-bin && return
		fi
	done
	if command -v go >/dev/null 2>&1; then
		go install github.com/tmuxpack/tpack/cmd/tpack@latest && return
	fi
	echo "  tpack: install manually"
}

# do_pacman / do_apt / do_dnf — install the package list for one manager.
# TODO: Make aur packages also file-configurable if we add more
do_pacman() {
	echo "  pacman"
	as_root pacman -Sy --noconfirm >/dev/null 2>&1 || true
	install_list "pacman" "$PKGS/arch.txt" as_root pacman -S --needed --noconfirm
	_aur=""
	for _h in yay paru; do
		if command -v "$_h" >/dev/null 2>&1; then
			_aur=$_h
			break
		fi
	done
	if [ -n "$_aur" ]; then
		"$_aur" -S --needed --noconfirm tmux-mem-cpu-load || true
	else
		echo "  AUR: no helper (yay/paru) — skipping tmux-mem-cpu-load"
	fi
}

do_apt() {
	echo "  apt"
	as_root apt-get update >/dev/null 2>&1 || true
	install_list "apt" "$PKGS/debian.txt" as_root apt-get install -y
	# Debian renames these binaries — link them to the names the config uses.
	mkdir -p "$HOME/.local/bin"
	command -v fdfind >/dev/null 2>&1 && ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
	command -v batcat >/dev/null 2>&1 && ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
	echo "  tmux-mem-cpu-load: not packaged for apt — build from source or skip"
}

do_dnf() {
	echo "  dnf"
	install_list "dnf" "$PKGS/fedora.txt" as_root dnf install -y
	echo "  tmux-mem-cpu-load: not packaged for dnf — build from source or skip"
}

# handle_unknown_distro — /etc/os-release matched no known family. Offer to
# probe for a package manager or exit; exit is the default.
# If we fail to prob then go to run_home which prompts again
handle_unknown_distro() {
	echo "  unrecognized Linux distro: '$distro'"
	_ans=""
	if [ -t 0 ]; then
		printf "  [p] detect a package manager   [e] exit  [p/e] "
		read -r _ans
	fi
	case "$_ans" in
	[Pp]*)
		if command -v pacman >/dev/null 2>&1; then
			do_pacman
		elif command -v apt-get >/dev/null 2>&1; then
			do_apt
		elif command -v dnf >/dev/null 2>&1; then
			do_dnf
		else
			echo "  no pacman/apt/dnf found on this system"
			run_home
		fi
		;;
	*)
		echo "  exiting — look up this distro's package manager and add it"
		echo "  to the case statement in install_packages.sh, then re-run"
		exit 0
		;;
	esac
}

# --- dispatch --------------------------------------------------------------

echo "--> packages"

case "$(uname -s)" in
Darwin)
	if ! command -v brew >/dev/null 2>&1; then
		echo "  Homebrew not found"
		run_home
	fi
	echo "  macOS — brew bundle"
	brew bundle --file="$PKGS/Brewfile"
	install_tpack
	;;
Linux)
	distro=""
	if [ -r /etc/os-release ]; then
		# shellcheck disable=SC1091,SC2154
		distro=$(. /etc/os-release 2>/dev/null && echo "${ID:-} ${ID_LIKE:-}")
	fi

	if [ "$(id -u)" -ne 0 ]; then
		if ! command -v sudo >/dev/null 2>&1; then
			echo "  no sudo on this system"
			run_home
		fi
		# Prime sudo and surface failures
		if ! sudo -v; then
			echo "  sudo is not usable for this user"
			run_home
		fi
	fi

	case " $distro " in
	*" arch "*) do_pacman ;;
	*" debian "* | *" ubuntu "*) do_apt ;;
	*" fedora "* | *" rhel "*) do_dnf ;;
	*) handle_unknown_distro ;;
	esac
	install_tpack
	;;
*)
	echo "  unsupported OS: $(uname -s)"
	exit 1
	;;
esac

echo "--> packages done"
