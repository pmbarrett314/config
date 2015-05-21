#!/bin/bash

if [ -z ${STUFFDIR+x} ]; then
	if [ -d $HOME/Code/stuff ]; then
		export STUFFDIR="$HOME/Code/stuff"
	else
		echo "The stuff repo could not be found."
	fi
fi


#if [ -d "$STUFFDIR/program/nano/" ]; then
#	cd $STUFFDIR/program/nano/
#	git clone https://github.com/nanorc/nanorc
#	cd nanorc/
#	make install TEXT=white
#	if[ ! -f ~/.nanorc ]; then
#		touch ~/.nanorc
#	fi
#	echo "include ~/.nano/syntax/ALL.nanorc" >> ~/.nanorc
#fi

if [ ! -f ~/.bash_profile ]; then
	cp $STUFFDIR/program/bash/platforms/mac.bash_profile ~/.bash_profile
else
	echo ".bash_profile already exists. Appending lines."
	cat $STUFFDIR/program/bash/platforms/mac.bash_profile >> ~/.bash_profile
fi

if [ ! -f ~/.bashrc ]; then
	cp $STUFFDIR/program/bash/default.bashrc ~/.bashrc
else
	echo ".bashrc already exists. Appending lines."
	cat $STUFFDIR/program/bash/default.bashrc >> ~/.bashrc
fi

if [ ! -f ~/.inputrc ]; then
	cp $STUFFDIR/program/readline/.inputrc ~/.inputrc
else
	echo ".inputrc already exists. Doing nothing."
fi