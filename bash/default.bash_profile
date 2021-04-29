export PERSONAL_CONFIG_DIR="$HOME/code/config"

INCLUDE="$PERSONAL_CONFIG_DIR/sh/.include"
[[ -f $INCLUDE ]] && source "$INCLUDE"

include_once_with_locals $PERSONAL_CONFIG_DIR/bash/.bash_profile
