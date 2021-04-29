#!/bin/bash
#homebrew tmux lives here
export PATH=$PATH:/usr/local/bin
#pipx powerline lives here
export PATH=$PATH:$HOME/.local/bin

# abort if we're already inside a TMUX session
[ "$TMUX" = "" ] || exit 0

# startup a "default" session if none currently exists
tmux has-session -t _default 2>/dev/null || tmux new-session -s _default -d

# present menu for user to choose which workspace to open
PS3="Please choose your session: "
if command -v tmuxinator >>/dev/null; then
	tmuxinators=$(tmuxinator list | tail -n +2)
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
