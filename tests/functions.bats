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
@test "get_os defined"                    { declare -f get_os; }

# helpers from sh/.functions
@test "nameterm defined"   { declare -f nameterm; }
@test "run_base64 defined" { declare -f run_base64; }
@test "cdir defined"       { declare -f cdir; }
@test "alert defined"      { declare -f alert; }
@test "st defined"         { declare -f st; }
@test "stt defined"        { declare -f stt; }
@test "join_msg defined"   { declare -f join_msg; }
