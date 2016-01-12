export PERSONAL_CONFIG_DIR="$HOME/code/config"

if [[ ! -a $HOME/.zshrc ]]; then
	cp $PERSONAL_CONFIG_DIR/zsh/default.zshrc $HOME/.zshrc
else
	mv $HOME/.zshrc $HOME/.old_zshrc
	cp $PERSONAL_CONFIG_DIR/zsh/default.zshrc $HOME/.zshrc
fi

if [[ ! -a $HOME/.zsh_local ]]; then
	touch .zsh_local
fi

