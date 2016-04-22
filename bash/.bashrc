# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
include $HOME/.bash_local


include $PERSONAL_CONFIG_DIR/bash/.bash_profile 

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
#arch expresses it this way.
#[[ $- != *i* ]] && return

include $PERSONAL_CONFIG_DIR/sh/.rc

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
export HISTSIZE=50000000
export HISTFILESIZE=10000000

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
if ((BASH_VERSINFO[0] >= 4)); then
	shopt -s globstar;
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi



include $PERSONAL_CONFIG_DIR/bash/.bash_prompt
include $PERSONAL_CONFIG_DIR/bash/.bash_stack

if [[ "$OSTYPE" == "darwin"* ]]; then
	include $PERSONAL_CONFIG_DIR/bash/platform/mac.bashrc
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

source virtualenvwrapper.sh
export WORKON_HOME=~/.virtualenvs

