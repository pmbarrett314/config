#!/bin/sh

if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [[  -a $HOME/.inputrc ]]; then
	mv $HOME/.inputrc $HOME/.old_inputrc
	echo "moving .inputrc to .old_inputrc"
fi
cp $PERSONAL_CONFIG_DIR/readline/.inputrc $HOME/.inputrc