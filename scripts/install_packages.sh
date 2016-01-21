#! /bin/sh

export PERSONAL_CONFIG_DIR="$HOME/code/config"


source $PERSONAL_CONFIG_DIR/scripts/os_info.sh 

if [[ $(get_distro) == "Arch" ]]; then
	if ! id -Gn $USER | grep '\bwheel\b' >> /dev/null; then
		echo "You need sudo privileges to do this"
		return 1
	fi
	package_list=(vim git zsh)
	pacman -S $package_list
fi