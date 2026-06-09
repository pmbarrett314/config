#!/usr/bin/env bats

@test "Brewfile installs tpack as cask" {
	run grep -E '^[[:space:]]*cask "tmuxpack/tpack/tpack"$' "$BATS_TEST_DIRNAME/../pkgs/Brewfile"
	[ "$status" -eq 0 ]
}
