# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
#arch expresses it this way.
#[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="ls:dir:c"

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist
shopt -s cdspell
shopt -s dotglob

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=50000000
export HISTFILESIZE=10000000



man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export EDITOR='kate -b'

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -f ***REMOVED*** ] && ! $MYFIRST; then
    . ***REMOVED***
fi

if [ -f ~/Code/stuff/byProgram/bash/.bash_ros ] && $MYROS; then
  . ~/Code/stuff/byProgram/bash/.bash_ros
fi

if [ -f ~/Code/stuff/byProgram/bash/.bash_myprompt ] && $MYPROMPT; then
  . ~/Code/stuff/byProgram/bash/.bash_myprompt
fi

if [ -f ~/Code/stuff/byProgram/bash/.bash_stack ] && $MYSTACK; then
    . ~/Code/stuff/byProgram/bash/.bash_stack
fi

if [ -f ~/Code/stuff/byProgram/bash/.bash_functions ] && $MYFUN; then
    . ~/Code/stuff/byProgram/bash/.bash_functions
fi

if [ -f ~/Code/stuff/byProgram/bash/.bash_android ] && $MYANDROID; then
  . ~/Code/stuff/byProgram/bash/.bash_android
fi

if [ -f ~/Code/stuff/byProgram/bash/platforms/mac.bashrc ] && [[ "$OSTYPE" == "darwin"* ]]; then
	. ~/Code/stuff/byProgram/bash/platforms/mac.bashrc
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/Code/stuff/byProgram/bash/.bash_aliases ]; then
    . ~/Code/stuff/byProgram/bash/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

