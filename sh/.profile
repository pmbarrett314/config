if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include $PERSONAL_CONFIG_DIR/sh/.env
include $PERSONAL_CONFIG_DIR/sh/.functions
include $PERSONAL_CONFIG_DIR/sh/.aliases