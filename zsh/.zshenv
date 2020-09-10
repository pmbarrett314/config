if [ -f "$HOME/.zshenv.local.pre" ]; then
	include_once "$HOME/.zshenv.local.pre"
fi

if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include_once_with_locals $PERSONAL_CONFIG_DIR/sh/.env

export ZDOTDIR=$PERSONAL_CONFIG_DIR/zsh

if [ -f "$HOME/.zshenv.local.post" ]; then
	include_once "$HOME/.zshenv.local.post"
fi