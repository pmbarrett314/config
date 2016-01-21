if [[ "$OSTYPE" == "darwin"* ]]; then

	alias showfiles='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
	alias hidefiles='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'


	alias safari='open -a Safari'
	alias itunes='open -a iTunes'


	# use textmate
	if /usr/local/bin/mate -v>/dev/null; then

		alias edit='open -a /usr/local/bin/mate'
	fi;
	
	alias bp='open ~/.bash_profile -W && source ~/.bash_profile'
	
	prank(){
		while true; do
			sleep 5
			say hello
		done
	}
	
	if hash ~/Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier; then
		alias terminal-notifier='~/Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier'
		alias notify-done='terminal-notifier -title "Terminal" -message "Terminal task completed!"'
		alias nd='notify-done'
	fi;
fi

