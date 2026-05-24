include_once "$HOME/.zshrc.local.pre"

if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include_once_with_locals $PERSONAL_CONFIG_DIR/sh/.rc

if [ -e "$HOME/.zshrc.local" ]; then
	echo "move .zshrc.local to .zshrc.local.pre"
	include $HOME/.zshrc.local
fi

setopt NO_BEEP
setopt AUTO_PUSHD
setopt AUTO_CD
setopt AUTO_NAME_DIRS
setopt PUSHD_SILENT
setopt RM_STAR_WAIT
[[ -z "$INTELLIJ_ENVIRONMENT_READER" ]] && setopt NO_CLOBBER
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

fpath+=~/.zfunc

# The following lines were added by compinstall
zstyle :compinstall filename '$PERSONAL_CONFIG_DIR/zsh/.zshrc'

autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
	compinit -d $HOME/.zcompdump
else
	compinit -C -d $HOME/.zcompdump
fi
# End of lines added by compinstall

# Plugin manager (install.sh clones antidote into XDG_DATA_HOME)
source "${XDG_DATA_HOME:-$HOME/.local/share}/antidote/antidote.zsh"

# Compile and cache the plugin list (static-source for fast warm starts).
# Cache dir is created by install.sh.
zsh_plugins_txt="$PERSONAL_CONFIG_DIR/zsh/.zsh_plugins.txt"
zsh_plugins_zsh="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/plugins.zsh"
if [[ ! -f $zsh_plugins_zsh || $zsh_plugins_txt -nt $zsh_plugins_zsh ]]; then
	antidote bundle <"$zsh_plugins_txt" >|"$zsh_plugins_zsh"
fi
source "$zsh_plugins_zsh"

# Prompt: starship if installed, fallback to handcrafted theme
if command -v starship >/dev/null 2>&1; then
	eval "$(starship init zsh)"
	# Show pwd in magenta after each directory change
	function _show_pwd_on_cd() { [[ -o interactive ]] && print -P "%F{magenta}%/%f"; }
	chpwd_functions+=(_show_pwd_on_cd)
else
	source "$PERSONAL_CONFIG_DIR/zsh/.zsh-theme"
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
_comp_options+=(globdots)

alias back="pushd"

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -e

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

include_once_with_locals $PERSONAL_CONFIG_DIR/sh/.bashzshrc

include_once "$HOME/.zshrc.local.post"
