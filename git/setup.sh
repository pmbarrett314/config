if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [[  -a $HOME/.gitconfig ]]; then
	mv $HOME/.gitconfig $HOME/.old_gitconfig
	echo "moving .gitconfig to .old_gitconfig"
fi
cp $PERSONAL_CONFIG_DIR/git/default.gitconfig $HOME/.gitconfig