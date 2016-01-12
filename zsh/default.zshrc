export PERSONAL_CONFIG_DIR="$HOME/code/config"

if [[ -a $PERSONAL_CONFIG_DIR/zsh/.zshrc ]]; then
	. $PERSONAL_CONFIG_DIR/zsh/.zshrc
fi

if [[ -a ~/.zsh_local ]]; then
	. ~/.zsh_local
fi