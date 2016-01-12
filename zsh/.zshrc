if [ ! -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

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

VIRTUAL_ENV_DISABLE_PROMPT=true
function omg_prompt_callback() {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "\e[0;31m(`basename ${VIRTUAL_ENV}`)\e[0m "
    fi
}

local ret_status="%(?,%{$fg_bold[green]%}:%) ,%{$fg_bold[red]%}:( %s)"
omg_ungit_prompt="%~ ${ret_status}%{$reset_color%}"
omg_second_line="%~ ${ret_status}%{$reset_color%}"
RPROMPT='%{$reset_color%}%T %{$fg_bold[white]%} %n@%m%{$reset_color%}'


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

unsetopt nomatch notify
bindkey -e

# The following lines were added by compinstall
zstyle :compinstall filename '/home/paul/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

source virtualenvwrapper.sh
export WORKON_HOME=~/.virtualenvs

setopt NO_BEEP
setopt AUTO_PUSHD
alias back="pushd"
setopt AUTO_CD
setopt AUTO_NAME_DIRS
setopt GLOB_COMPLETE
setopt PUSHD_SILENT
setopt RM_STAR_WAIT
setopt NO_CLOBBER
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt EXTENDED_GLOB



alias pacman='sudo pacman'

eval "$($(echo -n "dGhlZnVjayAtLWFsaWFzIG9vcHM=" | base64 -d))"

if [[ -a $PERSONAL_CONFIG_DIR/sh/.aliases ]]; then
	. $PERSONAL_CONFIG_DIR/sh/.aliases
fi

if [[ -a $PERSONAL_CONFIG_DIR/sh/.env ]]; then
	. $PERSONAL_CONFIG_DIR/sh/.env
fi