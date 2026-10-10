#!/usr/bin/env bats
# check if functions are present

load 'test_helper/common'

setup() {
	# Per-test
	load_dotfiles_env
	# .functions isn't sourced by .env, source it directly
	# shellcheck source=/dev/null
	. "$REPO_ROOT/sh/.functions"
}

# helpers from sh/.include
@test "include defined"                   { declare -f include; }
@test "include_once defined"              { declare -f include_once; }
@test "include_with_locals defined"       { declare -f include_with_locals; }
@test "include_once_with_locals defined"  { declare -f include_once_with_locals; }
@test "clear_load_vars defined"           { declare -f clear_load_vars; }
@test "prepend_path defined"              { declare -f prepend_path; }
@test "force_prepend_path defined"        { declare -f force_prepend_path; }
@test "get_os defined"                    { declare -f get_os; }

# helpers from sh/.functions
@test "nameterm defined"   { declare -f nameterm; }
@test "run_base64 defined" { declare -f run_base64; }
@test "cdir defined"       { declare -f cdir; }
@test "alert defined"      { declare -f alert; }
@test "st defined"         { declare -f st; }
@test "stt defined"        { declare -f stt; }
@test "join_msg defined"   { declare -f join_msg; }

# force_prepend_path must move an entry that is already in PATH, which is the
# whole reason it exists alongside prepend_path — see the note in sh/.include.
# Each case runs in a subshell: these overwrite PATH, and bats' own teardown
# still needs to find rm.
path_after() {
	(
		PATH="$1"
		"$2" "$3"
		echo "$PATH"
	)
}

@test "force_prepend_path moves an existing entry to the front" {
	[ "$(path_after /usr/local/bin:/usr/bin:/opt:/sbin force_prepend_path /opt)" \
		= "/opt:/usr/local/bin:/usr/bin:/sbin" ]
}

@test "force_prepend_path adds an entry that is absent" {
	[ "$(path_after /usr/bin force_prepend_path /opt)" = "/opt:/usr/bin" ]
}

@test "force_prepend_path collapses duplicates" {
	[ "$(path_after /usr/bin:/opt:/sbin:/opt force_prepend_path /opt)" \
		= "/opt:/usr/bin:/sbin" ]
}

@test "force_prepend_path ignores a directory that does not exist" {
	[ "$(path_after /usr/bin force_prepend_path /no/such/dir)" = "/usr/bin" ]
}

@test "prepend_path leaves an already-present entry alone" {
	[ "$(path_after /usr/bin:/opt prepend_path /opt)" = "/usr/bin:/opt" ]
}
