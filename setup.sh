#! /bin/sh

if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

. $PERSONAL_CONFIG_DIR/scripts/install_packages.sh

cd $PERSONAL_CONFIG_DIR && git submodule init && git submodule update

. $PERSONAL_CONFIG_DIR/sh/setup.sh

. $PERSONAL_CONFIG_DIR/zsh/setup.sh

. $PERSONAL_CONFIG_DIR/bash/setup.sh

. $PERSONAL_CONFIG_DIR/vim/setup.sh

. $PERSONAL_CONFIG_DIR/git/setup.sh

. $PERSONAL_CONFIG_DIR/nano/setup.sh

. $PERSONAL_CONFIG_DIR/readline/setup.sh
