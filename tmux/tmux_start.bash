#!/bin/bash
# Launched directly from iterm, not through shell
# Need to rebuild path to match login shell: ~/.local/bin, then port, then brew
PERSONAL_CONFIG_DIR="${PERSONAL_CONFIG_DIR:-$(
	unset CDPATH
	cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd -P
)}"
# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/sh/.include"

for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
	[ -x "$brew_bin" ] && eval "$("$brew_bin" shellenv)" && break
done
force_prepend_path /opt/local/sbin
force_prepend_path /opt/local/bin
force_prepend_path "$HOME/.local/bin"
export PATH

# abort if we're already inside a TMUX session
[ "$TMUX" = "" ] || exit 0

# startup a "default" session if none currently exists
tmux has-session -t _default 2>/dev/null || tmux new-session -s _default -d

# present menu for user to choose which workspace to open
PS3="Please choose your session: "
if command -v tmuxinator >/dev/null; then
	tmuxinators=$(tmuxinator list | tail -n +2 | tr -s '[:space:]' ' ')
else
	tmuxinators=""
fi

# shellcheck disable=SC2206,SC2207
options=($(tmux list-sessions -F "#S") "NEW SESSION" "ZSH" "BASH" $tmuxinators)
echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"; do
	case $opt in
	"NEW SESSION")
		read -r -p "Enter new session name: " SESSION_NAME
		tmux -2 new -s "$SESSION_NAME"
		break
		;;
	"ZSH")
		zsh -l -i
		break
		;;
	"BASH")
		bash -l -i
		break
		;;
	*)
		if [[ " ${tmuxinators[*]} " == *" $opt "* ]]; then
			tmuxinator start "$opt"
		else
			tmux -2 attach-session -t "$opt"
		fi
		break
		;;
	esac
done
