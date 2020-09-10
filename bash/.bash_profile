if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [ -f "$HOME/.bash_profile.local.pre" ]; then
	include_once "$HOME/.bash_profile.local.pre"
fi

include_once_with_locals $PERSONAL_CONFIG_DIR/sh/.profile

include_once_with_locals $PERSONAL_CONFIG_DIR/bash/.bashrc

if [ -f "$HOME/.bash_profile.local.post" ]; then
	include_once "$HOME/.bash_profile.local.post"
fi