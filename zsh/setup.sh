if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [[ -e $HOME/.zshenv ]]; then
	echo "moving .zshenv to .old_zshenv"
	mv $HOME/.zshenv $HOME/.old_zshenv
fi
cp $PERSONAL_CONFIG_DIR/zsh/default.zshenv $HOME/.zshenv

if [[ ! -e $HOME/.zshrc.local ]]; then
	touch $HOME/.zshrc.local
fi
