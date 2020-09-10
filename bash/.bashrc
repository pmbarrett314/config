# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


if [ -e "$HOME/.bash_local" ]; then
  echo "move .bash_local to .bashrc.local.pre"
  include $HOME/.bash_local
fi

if [ -f "$HOME/.bashrc.local.pre" ]; then
  include_once "$HOME/.bash_profile.local.pre"
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


include_once_with_locals $PERSONAL_CONFIG_DIR/sh/.rc

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



include_once $PERSONAL_CONFIG_DIR/bash/.bash_prompt
include_once $PERSONAL_CONFIG_DIR/bash/.bash_stack

if [[ "$OSTYPE" == "darwin"* ]]; then
	include_once $PERSONAL_CONFIG_DIR/bash/platform/mac.bashrc
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if command -v virtualenvwrapper.sh >> /dev/null 2>&1; then
  source virtualenvwrapper.sh
  export WORKON_HOME=~/.virtualenvs
fi


if [ -f "$HOME/.bashrc.local.post" ]; then
  include_once "$HOME/.bashrc.local.post"
fi
