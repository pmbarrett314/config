if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [ -z ${BASH_PROFILE_SOURCED+x} ] && [ -f $HOME/.bash_profile ]; then
	. $HOME/.bash_profile
fi

include $PERSONAL_CONFIG_DIR/bash/.bashrc
