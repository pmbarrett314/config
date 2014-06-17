alias bp='open ~/.bash_profile -W && source ~/.bash_profile'

# sets the title
echo -n -e "\033]0;Default Prompt\007"

#keep more history stuff

#Setup for prompt
didCD=true
function didCDfun {
	if $didCD ; then pwd; fi
		didCD=false
	}
export PROMPT_COMMAND="didCDfun"
export PS1=' \[\033[0;36m\][\t] $\[\e[0m\]'
export PATH=$PATH":~/bin"

alias pushd='didCD=true&&pushd'
alias popd='didCD=true&&popd'








alias showfiles='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'

#this version of pushd is not silent - alias cd='pushd'; the one below is silent
alias cd='pushd "$@" > /dev/null'
#this version of popd is not silent - alias back='popd'; the one below is silent
alias back='popd > /dev/null' 

##alias .="pwd"
##alias ..="cd .."

alias cdir='cd "$@" && dir .'

alias safari='open -a Safari'
alias itunes='open -a iTunes'


# use textmate
export EDITOR="/usr/local/bin/mate -w"
alias edit='open -a /usr/local/bin/mate'

