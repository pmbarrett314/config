#! /bin/sh

if [ -z "${PERSONAL_CONFIG_DIR+x}" ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

cd "$PERSONAL_CONFIG_DIR/nano/nanorc/" || return 1

make install TEXT=white
if [ ! -f "$HOME/.nanorc" ]; then
	touch "$HOME/.nanorc"
fi
echo "include $HOME/.nano/syntax/ALL.nanorc" >>~/.nanorc

cd "$PERSONAL_CONFIG_DIR" || return 1
