export PERSONAL_CONFIG_DIR="$HOME/code/config"
export BASH_PROFILE_SOURCED=1

include () {
    [[ -f "$1" ]] && source "$1"
}

include $PERSONAL_CONFIG_DIR/bash/.bash_profile 
