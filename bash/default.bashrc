if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

INCLUDE="$PERSONAL_CONFIG_DIR/code/config/sh/.include"
[[ -f $INCLUDE ]] && source "$INCLUDE"

include $PERSONAL_CONFIG_DIR/bash/.bashrc
