#!/bin/sh
# scripts/npm.sh — npm bootstrap for prefixes whose node ships without it.
# Not meant to be run on its own.
#
# Used by:
#   scripts/install_packages.sh      — at the end of do_macports
#
# MacPorts splits node and npm into separate ports, and the newest npm port
# (npm11) depends on nodejs24, which *conflicts* with nodejs26. So inside
# MacPorts you get node 26 with no npm, or npm with node two majors back.
# npm is pure JavaScript with every dependency bundled, so the registry
# tarball runs on whatever node is already here — no reason to downgrade.

NPM_DEST="${NPM_DEST:-$HOME/.local}"
NPM_REGISTRY="${NPM_REGISTRY:-https://registry.npmjs.org}"

# npm_needed — true when there is a node but no npm to go with it.
npm_needed() {
	command -v node >/dev/null 2>&1 && ! command -v npm >/dev/null 2>&1
}

# npm_fetch — install npm into $NPM_DEST/{bin,lib/node_modules}.
# Returns 1 if anything along the way fails.
npm_fetch() {
	if ! command -v node >/dev/null 2>&1; then
		echo "  npm: no node to run it — skipping" >&2
		return 1
	fi
	_tmp=$(mktemp -d -t npm-bootstrap) || return 1

	if ! curl -fsSL "$NPM_REGISTRY/npm/latest" -o "$_tmp/latest.json"; then
		echo "  npm: could not reach $NPM_REGISTRY" >&2
		rm -rf "$_tmp"
		return 1
	fi

	# node is the JSON parser we are guaranteed to have. engines is worth
	# reading: npm drops old node lines, and a mismatch fails at runtime
	# with a message that does not mention the version.
	_meta=$(node -e '
		const j = require(process.argv[1]);
		console.log([j.version, j.dist.tarball, j.dist.integrity,
			(j.engines && j.engines.node) || ""].join("\t"));
	' "$_tmp/latest.json") || {
		rm -rf "$_tmp"
		return 1
	}
	_ver=$(printf '%s' "$_meta" | cut -f1)
	_url=$(printf '%s' "$_meta" | cut -f2)
	_want=$(printf '%s' "$_meta" | cut -f3)
	_engines=$(printf '%s' "$_meta" | cut -f4)
	echo "  npm $_ver (needs node $_engines; have $(node --version))"

	if ! curl -fsSL "$_url" -o "$_tmp/npm.tgz"; then
		echo "  npm: download failed — $_url" >&2
		rm -rf "$_tmp"
		return 1
	fi
	# Guards a truncated or corrupted download, not a compromised registry:
	# the digest travels with the metadata it describes.
	_got="sha512-$(openssl dgst -sha512 -binary "$_tmp/npm.tgz" | openssl base64 -A)"
	if [ "$_got" != "$_want" ]; then
		echo "  npm: digest mismatch" >&2
		echo "    want $_want" >&2
		echo "    got  $_got" >&2
		rm -rf "$_tmp"
		return 1
	fi

	# The tarball contains a working npm, so it installs itself. Feed it the
	# bytes just verified rather than a package name, so this does not go
	# back to the registry for a second, unchecked copy.
	if ! tar -xzf "$_tmp/npm.tgz" -C "$_tmp"; then
		rm -rf "$_tmp"
		return 1
	fi
	node "$_tmp/package/bin/npm-cli.js" install -g "$_tmp/npm.tgz" \
		--prefix "$NPM_DEST" --no-audit --no-fund --loglevel=warn
	_rc=$?
	rm -rf "$_tmp"
	unset _tmp _meta _ver _url _want _engines _got
	return $_rc
}
