#!/bin/sh

shellcheck sh/.aliases
shellcheck sh/.env
shellcheck sh/.include
shellcheck sh/.functions
shellcheck sh/.profile
shellcheck sh/.rc
shellcheck sh/default.profile
shellcheck sh/setup.sh
shellcheck git/setup.sh 
shellcheck nano/setup.sh 
shellcheck readline/setup.sh 
shellcheck vim/setup.sh 
shellcheck setup.sh
shellcheck scripts/install_packages.sh