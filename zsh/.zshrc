if [ -f "$HOME/.zshrc.local.pre" ]; then
	include_once "$HOME/.zshrc.local.pre"
fi

if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include_once_with_locals $PERSONAL_CONFIG_DIR/sh/.rc

if [ -e "$HOME/.zshrc.local" ]; then
	echo "move .zshrc.local to .zshrc.local.pre"
	include $HOME/.zshrc.local
fi

include $PERSONAL_CONFIG_DIR/os-info/os_info.sh

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

# Auto-install antidote
ANTIDOTE_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/antidote"
if [ ! -d "$ANTIDOTE_HOME/.git" ]; then
	git clone --depth 1 https://github.com/mattmc3/antidote "$ANTIDOTE_HOME"
fi
source "$ANTIDOTE_HOME/antidote.zsh"

# Compile and cache the plugin list (static-source for fast warm starts)
zsh_plugins_txt="$PERSONAL_CONFIG_DIR/zsh/.zsh_plugins.txt"
zsh_plugins_zsh="$PERSONAL_CONFIG_DIR/zsh/.zsh_plugins.zsh"
if [[ ! -f $zsh_plugins_zsh || $zsh_plugins_txt -nt $zsh_plugins_zsh ]]; then
	antidote bundle <"$zsh_plugins_txt" >|"$zsh_plugins_zsh"
fi
source "$zsh_plugins_zsh"

# Prompt: starship if installed, fallback to handcrafted theme
if command -v starship >/dev/null 2>&1; then
	eval "$(starship init zsh)"
	# Show pwd in magenta after each directory change
	function _show_pwd_on_cd() { print -P "%F{magenta}%/%f"; }
	chpwd_functions+=(_show_pwd_on_cd)
else
	source "$PERSONAL_CONFIG_DIR/zsh/.zsh-theme"
fi

if [ -n "${DISPLAY+x}" ]; then
	if command -v st >>/dev/null; then
		export VISUAL="st"
	fi
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

command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh --disable-up-arrow)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

if [ -f "$HOME/.zshrc.local.post" ]; then
	include_once "$HOME/.zshrc.local.post"
fi
