#!/usr/bin/env bats

load 'test_helper/common'

@test "Brewfile installs tpack as cask" {
	run grep -E '^[[:space:]]*cask "tmuxpack/tpack/tpack"$' "$REPO_ROOT/pkgs/Brewfile"
	[ "$status" -eq 0 ]
}
