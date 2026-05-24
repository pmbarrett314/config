#!/usr/bin/env bats
# Smoke tests: basic functionality, .include and .env don't error and rerunning .env doesn't grow path

load 'test_helper/common'

@test "sh/.include sources cleanly with no stderr" {
	run bash -c '. "$0" 2>&1' "$REPO_ROOT/sh/.include"
	assert_success
	assert_output ""
}

@test "sh/.env sources cleanly with no stderr" {
	run bash -c '
		export PERSONAL_CONFIG_DIR="'"$REPO_ROOT"'"
		. "$PERSONAL_CONFIG_DIR/sh/.include"
		. "$PERSONAL_CONFIG_DIR/sh/.env"
	' 2>&1
	assert_success
	assert_output ""
}

@test "sh/.env is idempotent — PATH does not grow on re-source" {
	# Clears the include_once marker between sources so we are testing
	# the PATH-dedup helper itself, not just the no-op guard.
	run bash -c '
		export PERSONAL_CONFIG_DIR="'"$REPO_ROOT"'"
		. "$PERSONAL_CONFIG_DIR/sh/.include"
		. "$PERSONAL_CONFIG_DIR/sh/.env"
		first="$PATH"
		clear_load_vars
		. "$PERSONAL_CONFIG_DIR/sh/.env"
		[ "$first" = "$PATH" ]
	'
	assert_success
}
