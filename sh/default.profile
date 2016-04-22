export PERSONAL_CONFIG_DIR="$HOME/code/config"

INCLUDE="$PERSONAL_CONFIG_DIR/code/config/sh/.include"
[[ -f $INCLUDE ]] && source "$INCLUDE"

include $PERSONAL_CONFIG_DIR/sh/.profile