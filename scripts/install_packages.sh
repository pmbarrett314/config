#! /bin/sh

if [ -z ${PERSONAL_CONFIG_DIR+x} ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi


source $PERSONAL_CONFIG_DIR/scripts/os_info.sh 

id -Gn $USER | grep '\bwheel\b' >> /dev/null
CAN_SUDO=$?


DIST=`get_distro`

if [[ $DIST == "Arch" ]]; then
	PACKAGE_LIST="vim git zsh make"
	if [[ $CAN_SUDO == false ]]; then
		echo "You need sudo privileges to do this"
		return 1
	fi
	
	sudo pacman -S $PACKAGE_LIST
elif [[ $DIST == "Ubuntu" ]]; then
	PACKAGE_LIST="vim git zsh make python-pip"
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