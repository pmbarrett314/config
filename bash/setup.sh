if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [[  -a $HOME/.bashrc ]]; then
	mv $HOME/.bashrc $HOME/.old_bashrc
	echo "moving .bashrc to .old_bashrc"
fi
cp $PERSONAL_CONFIG_DIR/bash/default.bashrc $HOME/.bashrc

if [[ -a $HOME/.bash_profile ]]; then
	mv $HOME/.bash_profile $HOME/.old_bash_profile
	echo "moving .bash_profile to .old_bash_profile"
fi
cp $PERSONAL_CONFIG_DIR/bash/default.bash_profile $HOME/.bash_profile

if [[ ! -a $HOME/.bash_local ]]; then
	touch .bash_local
fi
