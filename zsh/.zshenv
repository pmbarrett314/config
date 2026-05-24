if [ -z "${PERSONAL_CONFIG_DIR+x}" ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

INCLUDE="$PERSONAL_CONFIG_DIR/sh/.include"
[[ -f "$INCLUDE" ]] && source "$INCLUDE"

typeset -U path PATH

include_once "$HOME/.zshenv.local.pre"

include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.env"

export ZDOTDIR="$PERSONAL_CONFIG_DIR/zsh"

include_once "$HOME/.zshenv.local.post"
