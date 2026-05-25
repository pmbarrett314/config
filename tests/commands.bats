#!/usr/bin/env bats
# Commands — every tool the install should put on PATH.

load 'test_helper/common'

setup_file() {
	load_dotfiles_env
}

# base shell tools
@test "bash on PATH" { command -v bash; }
@test "zsh on PATH"  { command -v zsh; }
@test "git on PATH"  { command -v git; }
@test "curl on PATH" { command -v curl; }

# ubi-managed tools
@test "eza on PATH"       { command -v eza; }
@test "bat on PATH"       { command -v bat; }
@test "fd on PATH"        { command -v fd; }
@test "rg on PATH"        { command -v rg; }
@test "fzf on PATH"       { command -v fzf; }
@test "zoxide on PATH"    { command -v zoxide; }
@test "starship on PATH"  { command -v starship; }
@test "delta on PATH"     { command -v delta; }
@test "lazygit on PATH"   { command -v lazygit; }
@test "gh on PATH"        { command -v gh; }
@test "tldr on PATH"      { command -v tldr; }
@test "navi on PATH"      { command -v navi; }
@test "fastfetch on PATH" { command -v fastfetch; }
@test "atuin on PATH"     { command -v atuin; }
@test "direnv on PATH"    { command -v direnv; }
@test "tpack on PATH"     { command -v tpack; }
@test "tmuxinator on PATH" { command -v tmuxinator; }

# system-PM-only tools
@test "tmux on PATH"        {
	skip_unless_full_install
	command -v tmux
}
@test "vim on PATH"         {
	skip_unless_full_install
	command -v vim
}
@test "nano on PATH"        {
	skip_unless_full_install
	command -v nano
}
