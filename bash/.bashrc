#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

if [ -e "$HOME/.bash_local" ]; then
	echo "move .bash_local to .bashrc.local.pre"
	include "$HOME/.bash_local"
fi

if [ -f "$HOME/.bashrc.local.pre" ]; then
	include_once "$HOME/.bashrc.local.pre"
fi

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.rc"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="ls:dir:c:..:...:....:....."

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist
shopt -s cdspell
shopt -s dotglob
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=5000000
export HISTFILESIZE=1000000

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
if ((BASH_VERSINFO[0] >= 4)); then
	shopt -s globstar
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# Prompt: starship if installed, fallback to handcrafted theme
if command -v starship >/dev/null 2>&1; then
	eval "$(starship init bash)"
	# Show pwd in magenta whenever the directory changes.
	_last_pwd=""
	_show_pwd_on_cd() {
		if [[ "$PWD" != "$_last_pwd" ]]; then
			printf '\x1B[1;35m%s\x1B[0m\n' "$PWD"
			_last_pwd="$PWD"
		fi
	}
	PROMPT_COMMAND="_show_pwd_on_cd; ${PROMPT_COMMAND:-:}"
else
	include_once "$PERSONAL_CONFIG_DIR/bash/.bash_prompt"
fi

alias back='cd -'

if [ "$(get_os)" = macos ]; then
	include_once "$PERSONAL_CONFIG_DIR/bash/platform/mac.bashrc"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		# shellcheck disable=SC1091
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		# shellcheck disable=1091
		. /etc/bash_completion
	fi
fi

# Tool integrations — fzf before atuin so atuin wins the Ctrl-R binding
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash --cmd cd)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init bash --disable-up-arrow)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"
command -v navi >/dev/null 2>&1 && eval "$(navi widget bash)"

if [ -f "$HOME/.bashrc.local.post" ]; then
	include_once "$HOME/.bashrc.local.post"
fi
