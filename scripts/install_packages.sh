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

get_distro() {
	if [ -r /etc/os-release ]; then
		# shellcheck disable=SC1091,SC2154
		. /etc/os-release 2>/dev/null && echo "${ID:-} ${ID_LIKE:-}"
		return 0
	fi
	echo "unknown"
}

# ubi helpers: ubi_bootstrap, ubi_project, ubi_fetch, UBI_BINS.
# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/scripts/ubi.sh"

# cargo helpers: cargo_bin, cargo_crate, cargo_env, cargo_fetch.
# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/scripts/cargo.sh"

# npm helpers: npm_needed, npm_fetch.
# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/scripts/npm.sh"

# gem helpers: gem_pkg, gem_fetch, gem_install_all, GEM_BINS.
# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/scripts/gem.sh"

# completion helpers: comp_install, comp_install_all, COMP_BINS.
# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/scripts/completions.sh"

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

pkg_tmuxinator() {
	echo "-->tmuxinator"
	distro=$(get_distro)
	case " $distro " in
	*" rhel "* | *" rocky "* | *" almalinux "* | *" centos "*)
		as_root dnf install -y ruby rubygems
		as_root gem install tmuxinator
		;;
	*" fedora "*)
		as_root dnf copr enable fcsm/tmuxinator -y
		as_root dnf install tmuxinator -y
		;;
	*) "$@" tmuxinator ;;
	esac

}

pkg_atuin() {
	echo "-->atuin"
	distro=$(get_distro)
	case " $distro " in
	*" arch "*)
		"$@" atuin
		;;
	*)
		curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
		;;
	esac
}

# install_package ENTRY INSTALL_CMD...
#
# ENTRY is "PKGNAME" or "PKGNAME:BINNAME" — BINNAME defaults to PKGNAME and
# is the binary we expect to be available after install.
#
# 1. if pkg_<PKGNAME> exists call it instead of INSTALL_CMD.
# 	It receives INSTALL_CMD as args
#	For per-package custom behavior
#	pkg_curl() { "$@" curl libcurl-openssl-dev; }
# 2. Else call INSTALL_CMD PKGNAME
# 3. Afterwards check if command exists
# 4. If not, fall back to ubi_fetch
install_package() {
	_entry=$1
	shift
	# Parse "PKGNAME[:BINNAME]".
	case $_entry in
	*:*)
		_pkg="${_entry%%:*}"
		_bin="${_entry#*:}"
		;;
	*)
		_pkg=$_entry
		_bin=$_entry
		;;
	esac
	# Build "pkg_<sanitized>" — `-` -> `_`
	_hook="pkg_"
	_rest=$_pkg
	while :; do
		case $_rest in
		*-*)
			_hook="${_hook}${_rest%%-*}_"
			_rest="${_rest#*-}"
			;;
		*)
			_hook="${_hook}${_rest}"
			break
			;;
		esac
	done
	# 1 + 2: hook or default PM call.
	if command -v "$_hook" >/dev/null 2>&1; then
		"$_hook" "$@"
	else
		"$@" "$_pkg"
	fi
	_rc=$?
	# 3: PM-provided binary is present — done.
	if [ $_rc -eq 0 ] && command -v "$_bin" >/dev/null 2>&1; then
		unset _entry _pkg _bin _hook _rest _rc
		return 0
	fi
	# 4: ubi fallback if we have a project for this binary.
	_project=$(ubi_project "$_bin")
	if [ -n "$_project" ]; then
		echo "  trying ubi fallback for $_bin <- $_project"
		if ubi_fetch "$_bin" "$_project"; then
			unset _entry _pkg _bin _hook _rest _rc _project
			return 0
		fi
	fi
	unset _entry _pkg _bin _hook _rest _rc _project
	return 1
}

# install_list LABEL LIST_FILE INSTALL_CMD... — install_package every
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
		if _out=$(install_package "$_pkg" "$@" 2>&1); then
			echo "  ok       $_pkg"
		else
			echo "  FAILED   $_pkg"
			printf '%s\n' "$_out" | tail -5 | sed 's/^/      /'
			_failed="$_failed $_pkg"
		fi
	done <"$_list"
	if [ -n "$_failed" ]; then
		echo "  $_label has no package for:$_failed"
		echo "  (install those another way)"
	fi
}

AUR_USER="${AUR_USER:-}"

if [ -z "$AUR_USER" ] && [ "$(id -u)" -eq 0 ]; then
	for _u in build builder aur _aurbuild ab; do
		if id "$_u" >/dev/null 2>&1; then
			AUR_USER=$_u
			break
		fi
	done
fi

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
		if [ "$(id -u)" -eq 0 ]; then
			if [ -n "$AUR_USER" ]; then
				echo "  AUR build as $AUR_USER"
				su "$AUR_USER" -s /bin/sh -c "$_aur -S --needed --noconfirm tmux-mem-cpu-load tmuxinator tpack" || true
			else
				echo "  AUR: running as root, no build user found (set AUR_USER) — skipping"
			fi
		else
			"$_aur" -S --needed --noconfirm tmux-mem-cpu-load tmuxinator tpack-bin || true
		fi
	fi
}

do_apt() {
	echo "  apt"
	as_root apt-get update >/dev/null 2>&1 || true
	install_list "apt" "$PKGS/debian.txt" as_root apt-get install -y
	echo "  tmux-mem-cpu-load: not packaged for apt — build from source or skip"
}

do_dnf() {
	echo "  dnf"
	# EPEL and CRB needed for RHEL (rocky, alma, rhel, centos)
	case " $distro " in
	*" rhel "* | *" rocky "* | *" almalinux "* | *" centos "*)
		echo "  enabling EPEL + CRB (RHEL-family)"
		as_root dnf install -y epel-release || true
		as_root dnf config-manager --set-enabled crb || true
		;;
	esac
	install_list "dnf" "$PKGS/fedora.txt" as_root dnf install -y
	echo "  tmux-mem-cpu-load: not packaged for dnf — build from source or skip"
}

# port_formula PORT — print the Homebrew formula PORT stands in for. Most
# names match; these do not, and MacPorts' are usually the more explicit.
port_formula() {
	case "$1" in
	ImageMagick7) echo imagemagick ;;
	gnupg2) echo gnupg ;;
	nodejs26) echo node ;;
	ruby40) echo ruby ;;
	*) echo "$1" ;;
	esac
}

# macports_formulae — print the Homebrew formula names pkgs/macports.txt now
# provides. do_macos_intel filters these out of the Brewfile: without it
# `brew bundle` happily reinstalls brew's git, vim and zsh from source right
# after MacPorts supplied them, and on Intel that means a source build.
macports_formulae() {
	_mlist="$PKGS/macports.txt"
	[ -r "$_mlist" ] || return 0
	while IFS= read -r _mentry || [ -n "$_mentry" ]; do
		case $_mentry in '' | \#*) continue ;; esac
		port_formula "${_mentry%% *}"
	done <"$_mlist"
	unset _mlist _mentry
}

# do_macports — install pkgs/macports.txt into /opt/local.
#
# Deliberately not routed through install_package: that probes for a binary
# afterwards and falls back to ubi, which is wrong here. Half this list is
# libraries with no binary at all, and `port` reports failure honestly, so its
# exit status is the answer. A missing port is collected and reported at the
# end rather than being fatal, matching the Linux lists.
do_macports() {
	_port=""
	if command -v port >/dev/null 2>&1; then
		_port=$(command -v port)
	elif [ -x /opt/local/bin/port ]; then
		_port=/opt/local/bin/port
	fi
	_list="$PKGS/macports.txt"
	if [ -z "$_port" ]; then
		echo "  MacPorts not installed — skipping $_list"
		unset _port _list
		return 0
	fi
	if [ ! -r "$_list" ]; then
		echo "  no port list at $_list"
		unset _port _list
		return 0
	fi
	if [ "$(id -u)" -ne 0 ] && ! sudo -v; then
		echo "  sudo is not usable for this user — skipping MacPorts"
		unset _port _list
		return 0
	fi
	_failed=""
	while IFS= read -r _entry || [ -n "$_entry" ]; do
		case $_entry in '' | \#*) continue ;; esac
		# Word splitting is deliberate: an entry may carry variants.
		# shellcheck disable=SC2086
		if _out=$(as_root "$_port" -N install $_entry 2>&1); then
			echo "  ok       $_entry"
		else
			echo "  FAILED   $_entry"
			printf '%s\n' "$_out" | tail -5 | sed 's/^/      /'
			_failed="$_failed ${_entry%% *}"
		fi
	done <"$_list"
	if [ -n "$_failed" ]; then
		echo "  MacPorts could not install:$_failed"
		echo "  (install those another way)"
	fi
	# nodejs26 ships only the node binary — see scripts/npm.sh.
	if npm_needed; then
		if npm_fetch; then
			echo "  ok       npm (registry tarball -> $NPM_DEST)"
		else
			echo "  FAILED   npm"
		fi
	fi
	# Gems go here rather than in do_macos_intel because the ruby they
	# install into is the one the port list just supplied — see
	# scripts/gem.sh.
	gem_install_all
	unset _port _list _entry _out _failed
}

# do_macos_intel — divert the pkgs/macos-x86_64.txt formulae away from brew,
# then run brew bundle with them filtered out so brew doesn't rebuild them
# from source behind us. Each entry goes to the first lane that can serve it:
# an upstream release asset via ubi, else a source build via cargo.
do_macos_intel() {
	_list="$PKGS/macos-x86_64.txt"
	# Seed the skip list with whatever MacPorts supplied and whatever the
	# gem lane serves, then add each binary this lane serves. Without the
	# gem entry brew reinstalls tmuxinator, and with it Homebrew's ruby.
	_skip="$(macports_formulae | tr '\n' ' ')$GEM_BINS"
	if [ -r "$_list" ]; then
		while IFS= read -r _entry || [ -n "$_entry" ]; do
			case $_entry in '' | \#*) continue ;; esac
			case $_entry in
			*:*)
				_pkg="${_entry%%:*}"
				_bin="${_entry#*:}"
				;;
			*)
				_pkg=$_entry
				_bin=$_entry
				;;
			esac
			_project=$(ubi_project "$_bin")
			_crate=$(cargo_crate "$_bin")
			if [ -n "$_project" ] &&
				ubi_fetch "$_bin" "$_project" >/dev/null 2>&1; then
				echo "  got      $_bin <- $_project"
				_skip="$_skip $_pkg"
			elif [ -n "$_crate" ] &&
				cargo_fetch "$_bin" "$_crate" >/dev/null 2>&1; then
				echo "  built    $_bin <- $_crate (cargo)"
				_skip="$_skip $_pkg"
			elif [ -z "$_project" ] && [ -z "$_crate" ]; then
				echo "  SKIP     $_bin (no mapping in scripts/{ubi,cargo}.sh)"
			else
				echo "  FAILED   $_bin (leaving it to brew)"
			fi
		done <"$_list"
	else
		echo "  no diversion list at $_list"
	fi
	# ubi and cargo install the executable and nothing else, so the
	# zsh completions a formula would have dropped into
	# share/zsh/site-functions have to be regenerated.
	comp_install_all

	# Filter the diverted formulae out of the Brewfile. One Brewfile stays
	# the source of truth for every Mac; only this arch skips lines from it.
	_bf="$PKGS/Brewfile"
	if [ -n "$_skip" ]; then
		_tmp=$(mktemp -t Brewfile.intel) || {
			echo "  mktemp failed — running brew bundle unfiltered"
			brew bundle --file="$_bf"
			return
		}
		cp "$_bf" "$_tmp"
		for _pkg in $_skip; do
			# Casks too, with or without a tap prefix: tpack is declared
			# `cask "tmuxpack/tpack/tpack"` but ships a single binary, so
			# this lane serves it and brew bundle must not put the cask
			# back -- it carries `depends_on formula: git, tmux`.
			grep -vE "^brew \"$_pkg\"\$|^cask \"([^\"]*/)?$_pkg\"\$" \
				"$_tmp" >"$_tmp.next" && mv "$_tmp.next" "$_tmp"
		done
		echo "  brew bundle, minus:$_skip"
		brew bundle --file="$_tmp"
		rm -f "$_tmp" "$_tmp.next"
		unset _tmp
	else
		brew bundle --file="$_bf"
	fi
	unset _list _skip _entry _pkg _bin _project _crate _bf
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
	case "$(uname -m)" in
	x86_64)
		# Homebrew dropped Intel macOS support in Sept 2026 — no more
		# bottles, so anything it installs here is built from source.
		# Divert the formulae in pkgs/macos-x86_64.txt to prebuilt
		# upstream binaries and let brew bundle handle the rest.
		echo "  macOS/Intel — ubi diversions + MacPorts + brew bundle"
		do_macports
		do_macos_intel
		;;
	*)
		echo "  macOS — brew bundle"
		brew bundle --file="$PKGS/Brewfile"
		;;
	esac
	;;
Linux)
	distro=$(get_distro)

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
	;;
*)
	echo "  unsupported OS: $(uname -s)"
	exit 1
	;;
esac

echo "--> packages done"
