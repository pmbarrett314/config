include () {
    [[ -f "$1" ]] && source "$1"
}

export PERSONAL_CONFIG_DIR=$HOME/code/config

include $PERSONAL_CONFIG_DIR/zsh/.zshenv

export ZDOTDIR=$PERSONAL_CONFIG_DIR/zsh
