#!/bin/bash

if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [[ -e $HOME/.bashrc ]]; then
	mv "$HOME/.bashrc" "$HOME/.old_bashrc"
	echo "moving .bashrc to .old_bashrc"
fi
cp "$PERSONAL_CONFIG_DIR/bash/default.bashrc" "$HOME/.bashrc"

if [[ -e $HOME/.bash_profile ]]; then
	mv "$HOME/.bash_profile" "$HOME/.old_bash_profile"
	echo "moving .bash_profile to .old_bash_profile"
fi
cp "$PERSONAL_CONFIG_DIR/bash/default.bash_profile" "s$HOME/.bash_profile"
