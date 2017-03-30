#!/bin/sh

run_base64(){
	OS=$(get_os)

	if [ "$OS" = "macos" ] ; then
		eval "$(printf "%s" "$1" | base64 -D)"
	else	
		eval "$(printf "%s" "$1" | base64 -d))"
	fi
}

run_base64 $(echo "touch test" | base64)