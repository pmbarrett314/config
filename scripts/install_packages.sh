#! /bin/sh

if [ -z "${PERSONAL_CONFIG_DIR+x}" ]; then
	echo "PERSONAL_CONFIG_DIR is not set"
	return 1
fi

# shellcheck source=/dev/null
. "$PERSONAL_CONFIG_DIR/os-info/os_info.sh" 


#https://superuser.com/a/1183480/317458
CAN_SUDO=A=$(sudo -n -v 2>&1);test -z "$A" || echo $A|grep -q asswor


DIST=$(get_distro)

if [ "$DIST" = "Arch" ]; then
	PACKAGE_LIST="vim git zsh make python-pip"
	if [ "$CAN_SUDO" = false ]; then
		echo "You need sudo privileges to do this"
		return 1
	fi
	
	sudo pacman -S "$PACKAGE_LIST"
elif [ "$DIST" = "Ubuntu" ]; then
	PACKAGE_LIST="vim git zsh make python-pip"
	if [ "$CAN_SUDO" = false ]; then
		echo "You need sudo privileges to do this"
		return 1
	fi

	sudo apt-get install "$PACKAGE_LIST"

else 
	echo "Unknown distro: $DIST"
	echo "Not installing packages"
fi

if command -v pip >> /dev/null 2>&1 && [ $CAN_SUDO = true ]; then
	sudo pip install virtualenvwrapper

	run_base64 "c3VkbyBwaXAgaW5zdGFsbCB0aGVmdWNrCg=="
fi


