if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [[ -a $HOME/.profile ]]; then
	mv $HOME/.profile $HOME/.old_profile
	echo "moving .profile to .old_profile"
fi
cp $PERSONAL_CONFIG_DIR/sh/default.profile $HOME/.profile