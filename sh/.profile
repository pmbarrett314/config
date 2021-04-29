#!/bin/sh

#used for things that should be cross-shell (or at least bash and zsh), for both interactive and noninteractive, login and non-login
#loads .env
#loads .rc if running interactively

if [ -f "$HOME/.profile.local.pre" ]; then
	include_once "$HOME/.profile.local.pre"
fi


if [ -z "${PERSONAL_CONFIG_DIR+x}" ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.env"

case "$-" in
*i*)	include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.rc" ;;
*)	 : ;;
esac

if [ -f "$HOME/.profile.local.post" ]; then
	include_once "$HOME/.profile.local.post"
fi
