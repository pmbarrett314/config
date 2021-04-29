if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [ -f "$HOME/.zprofile.local.pre" ]; then
	include_once "$HOME/.zprofile.local.pre"
fi

include_once_with_locals "$PERSONAL_CONFIG_DIR/sh/.profile"

if [ -f "$HOME/.zprofile.local.post" ]; then
	include_once "$HOME/.zprofile.local.post"
fi
