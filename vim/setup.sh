#!/bin/sh

if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [[  -a $HOME/.vimrc ]]; then
	mv $HOME/.vimrc $HOME/.old_vimrc
	echo "moving .vimrc to .old_vimrc"
fi
cp $PERSONAL_CONFIG_DIR/vim/default.vimrc $HOME/.vimrc

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim