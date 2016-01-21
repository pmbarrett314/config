#! /bin/sh

export PERSONAL_CONFIG_DIR="$HOME/code/config"


source $PERSONAL_CONFIG_DIR/scripts/os_info.sh 

id -Gn $USER | grep '\bwheel\b' >> /dev/null
CAN_SUDO=$?

if [[ $(get_distro) == "Arch" ]]; then
	if [[ $CAN_SUDO == false ]]; then
		echo "You need sudo privileges to do this"
		return 1
	fi
	package_list=(vim git zsh)
	pacman -S $package_list
fi

if command -v pip >> /dev/null && [[ $CAN_SUDO == true ]]; then
	sudo pip install virtualenvwrapper
fi