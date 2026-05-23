#!/bin/bash

if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include_once "$HOME/.bash_profile.local.pre"

include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.profile"

include_once_with_locals "$PERSONAL_CONFIG_DIR/bash/.bashrc"

include_once "$HOME/.bash_profile.local.post"
