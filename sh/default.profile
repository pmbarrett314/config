#!/bin/sh

export PERSONAL_CONFIG_DIR="$HOME/code/config"


INCLUDE="$PERSONAL_CONFIG_DIR/sh/.include"

# shellcheck source=/dev/null
[ -f "$INCLUDE" ] && . "$INCLUDE"

include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.profile"
