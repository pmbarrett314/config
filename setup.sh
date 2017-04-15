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

if command -v zsh >/dev/null 2>&1; then
	# shellcheck source=/dev/null
	. "$PERSONAL_CONFIG_DIR/zsh/setup.zsh"
fi

if command -v bash >/dev/null 2>&1; then
	# shellcheck source=/dev/null
	. "$PERSONAL_CONFIG_DIR/bash/setup.sh"
fi

if command -v vim >/dev/null 2>&1; then
	# shellcheck source=/dev/null
	. "$PERSONAL_CONFIG_DIR/vim/setup.sh"
fi

if command -v git >/dev/null 2>&1; then
	# shellcheck source=/dev/null
	. "$PERSONAL_CONFIG_DIR/git/setup.sh"
fi

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/nano/setup.sh" || return 1

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/readline/setup.sh"
