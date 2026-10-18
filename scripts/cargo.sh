#!/bin/sh
# scripts/cargo.sh — cargo lane helpers + crate map. Not meant to be run on
# its own.
#
# Used by:
#   scripts/install_packages.sh      — last-resort fallback when neither the
#                                      system PM nor ubi can supply a binary
# Last resort. Compiles from source, so prefer tools that fetch binaries.

CARGO_DEST="${CARGO_DEST:-$HOME/.local}"

# cargo_bin — print a usable cargo, empty if there is none. rustup's cargo is
# fine and is the usual source; no system package needs to provide it.
cargo_bin() {
	if command -v cargo >/dev/null 2>&1; then
		command -v cargo
	elif [ -x "$HOME/.cargo/bin/cargo" ]; then
		echo "$HOME/.cargo/bin/cargo"
	fi
}

# cargo_crate BINNAME — print the crate that provides BINNAME, empty if this
# lane does not know it. Mirrors ubi_project in scripts/ubi.sh.
cargo_crate() {
	case "$1" in
	# delta 0.20.1 dropped x86_64-apple-darwin from its release assets, and
	# MacPorts has no darwin_24.x86_64 archive for it either, so Intel Macs
	# have to build it. See pkgs/macos-x86_64.txt.
	delta) echo git-delta ;;
	# eza has never shipped a macOS asset — every release carries Linux and
	# Windows only — and it is EUPL-1.2, so packages.macports.org 404s it
	# the way it does git. Nothing prebuilt exists for Intel macOS.
	eza) echo eza ;;
	esac
}

# cargo_env CRATE — print VAR=value assignments to prefix the build with,
# empty for most crates. Only needed where a build script would otherwise
# link something out of another prefix.
cargo_env() {
	case "$1" in
	# libgit2-sys links whatever libgit2 pkg-config finds — on a machine
	# with Homebrew installed that is /usr/local's. Force the vendored copy
	# so the binary needs nothing outside /usr/lib. eza's --git support goes
	# through the same crate and needs the same treatment.
	git-delta | eza) echo "LIBGIT2_NO_PKG_CONFIG=1 PKG_CONFIG_PATH=" ;;
	esac
}

# cargo_fetch BINNAME CRATE — build CRATE into $CARGO_DEST/bin.
# Returns 1 if there is no cargo, or if the build fails.
cargo_fetch() {
	_cargo=$(cargo_bin)
	if [ -z "$_cargo" ]; then
		echo "  cargo: not found — cannot build $1" >&2
		unset _cargo
		return 1
	fi
	mkdir -p "$CARGO_DEST/bin"
	# Word splitting on cargo_env is the point: it yields VAR=value words.
	# shellcheck disable=SC2046
	env $(cargo_env "$2") "$_cargo" install "$2" \
		--root "$CARGO_DEST" --locked
	_rc=$?
	unset _cargo
	return $_rc
}
