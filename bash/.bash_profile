if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [ -n ${BASH_PROFILE_SOURCED+x} ]; then
	return
fi


export BASH_PROFILE_SOURCED=1

include $PERSONAL_CONFIG_DIR/sh/.profile

include $HOME/.bashrc
