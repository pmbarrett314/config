if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

#some defaults
export ANTIGEN_PLUGINS="sudo:git:pip:python:autopep8:virtualenv:zsh-users/zsh-syntax-highlighting"

function add_to_antigen_plugins(){
	remove_from_antigen_plugins $1
	ANTIGEN_PLUGINS+=":$1"
}

function remove_from_antigen_plugins(){
 	escaped_lhs=$(printf '%s\n' ":$1:" | sed 's:[][\/.^$*]:\\&:g')
    export ANTIGEN_PLUGINS=$(echo "$ANTIGEN_PLUGINS"|sed "s/$escaped_lhs/:/")
    escaped_lhs=$(printf '%s\n' ":$1" | sed 's:[][\/.^$*]:\\&:g')
    export ANTIGEN_PLUGINS=$(echo "$ANTIGEN_PLUGINS"|sed "s/$escaped_lhs/:/")
    escaped_lhs=$(printf '%s\n' "$1:" | sed 's:[][\/.^$*]:\\&:g')
    export ANTIGEN_PLUGINS=$(echo "$ANTIGEN_PLUGINS"|sed "s/$escaped_lhs/:/")

}


include $PERSONAL_CONFIG_DIR/sh/.rc

include $HOME/.zshrc.local

include $PERSONAL_CONFIG_DIR/os-info/os_info.sh 


setopt NO_BEEP
setopt AUTO_PUSHD
setopt AUTO_CD
setopt AUTO_NAME_DIRS
setopt PUSHD_SILENT
setopt RM_STAR_WAIT
setopt NO_CLOBBER
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt EXTENDED_GLOB
setopt GLOB_COMPLETE

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

unsetopt NOMATCH 
unsetopt NOTIFY

# The following lines were added by compinstall
zstyle :compinstall filename '$PERSONAL_CONFIG_DIR/zsh/.zshrc'

autoload -Uz compinit
compinit -d $HOME/.zcompdump
# End of lines added by compinstall

export ANTIGEN_COMPDUMPFILE=$HOME/.zcompdump

source $PERSONAL_CONFIG_DIR/zsh/antigen/antigen.zsh


antigen use oh-my-zsh

for PLUGIN in $(echo $ANTIGEN_PLUGINS | sed "s/:/ /g"); do antigen bundle $PLUGIN; done


antigen theme $PERSONAL_CONFIG_DIR/zsh --no-local-clone


antigen apply

if [ -n "${DISPLAY+x}" ]; then
	if command -v st >> /dev/null; then
		export VISUAL="st"
	fi
fi

source virtualenvwrapper.sh
export WORKON_HOME=~/.virtualenvs

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
_comp_options+=(globdots)

alias back="pushd"

OS=`get_os`

if [[ $OS = "macos" ]] ; then
	eval "$($(echo -n "dGhlZnVjayAtLWFsaWFzIG9vcHM=" | base64 -D))"
else	
	eval "$($(echo -n "dGhlZnVjayAtLWFsaWFzIG9vcHM=" | base64 -d))"
fi

bindkey -e

include $HOME/.zshrc.local.post
