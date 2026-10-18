#!/bin/sh
# scripts/gem.sh — gem lane helpers + gem map. Not meant to be run on its own.
#
# Used by:
#   scripts/install_packages.sh      — at the end of do_macports, because the
#                                      ruby it installs into comes from there
#
# Currently just for tmuxinator

GEM_DEST="${GEM_DEST:-$HOME/.local}"

# GEM_BINS — the executables this lane provides.
GEM_BINS="${GEM_BINS:-tmuxinator}"

# gem_pkg BINNAME — print the gem that provides BINNAME, empty if this lane
# does not know it. Mirrors ubi_project in scripts/ubi.sh and cargo_crate in
# scripts/cargo.sh.
gem_pkg() {
	case "$1" in
	tmuxinator) echo tmuxinator ;;
	esac
}

# gem_bin — print a usable gem, empty if there is none. Prefers whatever is on
# PATH, which under MacPorts means `port select --set ruby ruby40` has been
# run; falls back to the versioned name the port installs regardless.
gem_bin() {
	if command -v gem >/dev/null 2>&1; then
		command -v gem
	else
		for _g in /opt/local/bin/gem4.0 /opt/local/bin/gem3.4 /usr/bin/gem; do
			[ -x "$_g" ] && echo "$_g" && break
		done
		unset _g
	fi
}

# gem_fetch BINNAME GEM — install GEM for this user and link BINNAME into
# $GEM_DEST/bin. Returns 1 if there is no gem, or if the install fails.
gem_fetch() {
	_gem=$(gem_bin)
	if [ -z "$_gem" ]; then
		echo "  gem: not found — cannot install $2" >&2
		unset _gem
		return 1
	fi
	# --no-document because the ri/rdoc trees are several times the size of
	# the gem and nothing here reads them.
	if ! "$_gem" install --user-install --no-document "$2"; then
		unset _gem
		return 1
	fi
	_bindir=$("$_gem" environment user_gemdir 2>/dev/null)/bin
	if [ ! -x "$_bindir/$1" ]; then
		echo "  gem: $2 installed but left no $1 in $_bindir" >&2
		unset _gem _bindir
		return 1
	fi
	mkdir -p "$GEM_DEST/bin" || {
		unset _gem _bindir
		return 1
	}
	ln -sfn "$_bindir/$1" "$GEM_DEST/bin/$1"
	unset _gem _bindir
}

# gem_install_all — install every GEM_BINS entry that is not already present.
gem_install_all() {
	_failed=""
	for _b in $GEM_BINS; do
		_p=$(gem_pkg "$_b")
		if [ -z "$_p" ]; then
			echo "  SKIP     $_b (no gem mapping)"
			continue
		fi
		if command -v "$_b" >/dev/null 2>&1; then
			echo "  ok       $_b (already present)"
			continue
		fi
		if gem_fetch "$_b" "$_p" >/dev/null 2>&1; then
			echo "  got      $_b <- gem $_p"
		else
			echo "  FAILED   $_b <- gem $_p"
			_failed="$_failed $_b"
		fi
	done
	[ -n "$_failed" ] && echo "  gem lane could not install:$_failed"
	unset _failed _b _p
	return 0
}
