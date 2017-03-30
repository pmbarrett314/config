#! /bin/sh

if [ -z "${PERSONAL_CONFIG_DIR+x}" ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/scripts/install_packages.sh"

cd "$PERSONAL_CONFIG_DIR" && git submodule init && git submodule update

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/sh/setup.sh"

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/zsh/setup.sh"

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/bash/setup.sh"

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/vim/setup.sh"

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/git/setup.sh"

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/nano/setup.sh" || return 1

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/readline/setup.sh"
