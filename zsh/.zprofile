if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include_once "$HOME/.zprofile.local.pre"

include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.profile"

include_once "$HOME/.zprofile.local.post"
