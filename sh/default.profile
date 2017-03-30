#!/bin/sh

export PERSONAL_CONFIG_DIR="$HOME/code/config"


INCLUDE="$PERSONAL_CONFIG_DIR/sh/.include"

# shellcheck source=/dev/null
[ -f "$INCLUDE" ] && source "$INCLUDE"

include "$PERSONAL_CONFIG_DIR/sh/.profile"