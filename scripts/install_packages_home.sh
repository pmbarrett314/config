#!/bin/sh
# install_packages_home.sh — bulk-install portable userland CLI binaries
# into ~/.local/bin via ubi. Use when there is no system package manager,
# or via `install.sh --home` if we don't have root.

set -u

PERSONAL_CONFIG_DIR="${PERSONAL_CONFIG_DIR:-$(
	unset CDPATH
	cd -- "$(dirname -- "$0")/.." >/dev/null 2>&1 && pwd -P
)}"

# ubi helpers: ubi_bootstrap, ubi_project, ubi_fetch, UBI_BINS.
# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/scripts/ubi.sh"

echo "--> home install -> $UBI_DEST"
mkdir -p "$UBI_DEST"

if ! ubi_bootstrap; then
	echo "  could not bootstrap ubi — see https://github.com/houseabsolute/ubi"
	exit 1
fi

# fetch BINNAME — install BINNAME via ubi using its project from ubi_project.
# Skip if already present.
fetch() {
	if command -v "$1" >/dev/null 2>&1; then
		echo "  ok       $1 (already present)"
		return 0
	fi
	_p=$(ubi_project "$1")
	if [ -z "$_p" ]; then
		echo "  SKIP     $1 (no ubi mapping)"
		return 1
	fi
	if ubi_fetch "$1" "$_p"; then
		echo "  got      $1 <- $_p"
	else
		echo "  FAILED   $1 <- $_p"
		return 1
	fi
}

_failed=""
for _b in $UBI_BINS; do
	fetch "$_b" || _failed="$_failed $_b"
done

[ -n "$_failed" ] && echo "  could not install:$_failed"

echo "--> tmuxinator"
curl https://mise.run | sh
eval "$("$HOME/.local/bin/mise" activate bash)"
"$HOME/.local/bin/mise" settings ruby.compile=false
"$HOME/.local/bin/mise" use -g ruby@latest
"$HOME/.local/bin/mise" x -- gem install tmuxinator

echo "--> home install done — open a new shell so $UBI_DEST is on PATH"
