#!/bin/sh

#used for things that should be cross-shell (or at least bash and zsh), for both interactive and noninteractive, login and non-login
#loads .env
#loads .rc if running interactively

include_once "$HOME/.profile.local.pre"


if [ -z "${PERSONAL_CONFIG_DIR+x}" ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.env"

case "$-" in
*i*)	include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.rc" ;;
*)	 : ;;
esac

include_once "$HOME/.profile.local.post"
