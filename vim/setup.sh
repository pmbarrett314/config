#!/bin/sh

if [ -z "${PERSONAL_CONFIG_DIR+x}" ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

if [ -e "$HOME/.vimrc" ]; then
	mv "$HOME/.vimrc" "$HOME/.old_vimrc"
	echo "moving .vimrc to .old_vimrc"
fi
cp "$PERSONAL_CONFIG_DIR/vim/default.vimrc" "$HOME/.vimrc"

echo "Launch vim once so vim-plug can install plugins."
echo "Then run :LspInstallServer in a file to add a language server."
