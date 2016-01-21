if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

include $PERSONAL_CONFIG_DIR/sh/.profile

if [[ "$OSTYPE" == "darwin"* ]] && [ -f ~.bashrc ]; then
	. ~.bashrc
fi