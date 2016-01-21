export PERSONAL_CONFIG_DIR="$HOME/code/config"

include () {
    [[ -f "$1" ]] && source "$1"
}

include $PERSONAL_CONFIG_DIR/sh/.profile