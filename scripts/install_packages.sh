#! /bin/sh

export PERSONAL_CONFIG_DIR="$HOME/code/config"


source $PERSONAL_CONFIG_DIR/scripts/os_info.sh 

id -Gn $USER | grep '\bwheel\b' >> /dev/null
CAN_SUDO=$?

PACKAGE_LIST="vim git zsh make"
DIST=`get_distro`

if [[ $DIST == "Arch" ]]; then
	if [[ $CAN_SUDO == false ]]; then
		echo "You need sudo privileges to do this"
		return 1
	fi
	
	sudo pacman -S $PACKAGE_LIST
elif [[ $DIST == "Ubuntu" ]]; then
	if [[ $CAN_SUDO == false ]]; then
		echo "You need sudo privileges to do this"
		return 1
	fi

	sudo apt-get install $PACKAGE_LIST

else 
	echo $DIST
fi

if command -v pip >> /dev/null && [[ $CAN_SUDO == true ]]; then
	sudo pip install virtualenvwrapper
fi