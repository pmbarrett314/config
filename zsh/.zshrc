if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include $HOME/.zshrc.local


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
zstyle :compinstall filename '/home/paul/.zshrc'

autoload -Uz compinit
compinit -d $HOME/.zcompdump
# End of lines added by compinstall
export ANTIGEN_COMPDUMPFILE=$HOME/.zcompdump

source $PERSONAL_CONFIG_DIR/zsh/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle sudo
antigen bundle git
antigen bundle pip
antigen bundle python
antigen bundle autopep8
antigen bundle virtualenv
antigen bundle sublime
antigen bundle zsh-users/zsh-syntax-highlighting
antigen-bundle arialdomartini/oh-my-git

antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

antigen apply

if [ -n "${DISPLAY+x}" ]; then
	if command -v st >> /dev/null; then
		export VISUAL="st"
	fi
fi


local ret_status="%(?,%{$fg_bold[green]%}:%) ,%{$fg_bold[red]%}:( %s)"
omg_ungit_prompt="%~ ${ret_status}%{$reset_color%}"
omg_second_line="%~ ${ret_status}%{$reset_color%}"
RPROMPT='%{$reset_color%}%T %{$fg_bold[white]%} %n@%m%{$reset_color%}'

VIRTUAL_ENV_DISABLE_PROMPT=true
function omg_prompt_callback() {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "\e[0;31m(`basename ${VIRTUAL_ENV}`)\e[0m "
    fi
}

source virtualenvwrapper.sh
export WORKON_HOME=~/.virtualenvs

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

alias back="pushd"
alias pacman='sudo pacman'

eval "$($(echo -n "dGhlZnVjayAtLWFsaWFzIG9vcHM=" | base64 -d))"

bindkey -e