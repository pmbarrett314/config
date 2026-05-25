#!/usr/bin/env bats
# Strict-mode survival — every rc file in sh/ should source cleanly under `set -eu`

load 'test_helper/common'

# source_strict FILE — source $REPO_ROOT/sh/.include and $REPO_ROOT/sh/FILE
# in a fresh `bash -c` subshell under `set -eu`, echo SURVIVED on success.
source_strict() {
	bash -c '
		set -eu
		export PERSONAL_CONFIG_DIR="$1"
		. "$PERSONAL_CONFIG_DIR/sh/.include"
		. "$PERSONAL_CONFIG_DIR/sh/$2"
		echo SURVIVED
	' _ "$REPO_ROOT" "$1"
}

@test ".include survives set -eu (incl. missing-file include calls)" {
	run bash -c '
		set -eu
		export PERSONAL_CONFIG_DIR="$1"
		. "$PERSONAL_CONFIG_DIR/sh/.include"
		include      /nonexistent/path
		include_once /nonexistent/path
		echo SURVIVED
	' _ "$REPO_ROOT"
	assert_success
	assert_output --partial SURVIVED
}

@test ".env survives set -eu" {
	run source_strict .env
	assert_success
	assert_output --partial SURVIVED
}

@test ".aliases survives set -eu" {
	run source_strict .aliases
	assert_success
	assert_output --partial SURVIVED
}

@test ".functions survives set -eu" {
	run source_strict .functions
	assert_success
	assert_output --partial SURVIVED
}

@test ".profile survives set -eu" {
	run source_strict .profile
	assert_success
	assert_output --partial SURVIVED
}
