#!/usr/bin/env bats
# check if aliases are present

load 'test_helper/common'

setup() {
	# Per-test: aliases live in the shell's alias table,
	# which doesn't propagate from setup_file's process to per-test
	# subshells.
	load_dotfiles_env
	# .aliases isn't sourced by .env, source it directly
	# shellcheck source=/dev/null
	. "$REPO_ROOT/sh/.aliases"
}

# always defined
@test "grep alias defined"  { alias grep  >/dev/null; }
@test "fgrep alias defined" { alias fgrep >/dev/null; }
@test ".. alias defined"    { alias ..    >/dev/null; }
@test "... alias defined"   { alias ...   >/dev/null; }
@test "ll alias defined"    { alias ll    >/dev/null; }
@test "la alias defined"    { alias la    >/dev/null; }
@test "l alias defined"     { alias l     >/dev/null; }
@test "ls alias defined"    { alias ls    >/dev/null; }
@test "dir alias defined"   { alias dir   >/dev/null; }
@test "c alias defined"     { alias c     >/dev/null; }
@test "cls alias defined"   { alias cls   >/dev/null; }
@test "cd.. alias defined"  { alias cd..  >/dev/null; }

# always set on unixes
@test "del alias defined"     { alias del     >/dev/null; }
@test "zap alias defined"     { alias zap     >/dev/null; }
@test "deltree alias defined" { alias deltree >/dev/null; }

# only set when tools are present
@test "lg alias defined when lazygit present" {
	command -v lazygit >/dev/null 2>&1 || skip "no lazygit"
	alias lg >/dev/null
}

@test "dis alias defined when eza present" {
	command -v eza >/dev/null 2>&1 || skip "no eza"
	alias dis >/dev/null
}

@test "update alias defined when brew present" {
	command -v brew >/dev/null 2>&1 || skip "no brew"
	alias update >/dev/null
}
