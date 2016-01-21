if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include () {
    [[ -f "$1" ]] && source "$1"
}

include $PERSONAL_CONFIG_DIR/sh/.env