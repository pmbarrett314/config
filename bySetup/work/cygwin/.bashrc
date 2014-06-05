alias bp='open ~/.bash_profile -W && source ~/.bash_profile'

# this customizes the prompt - remove the \n to make the cursor to be on the same line

# sets the title
echo -n -e "\033]0;Default Prompt\007"

#keep more history stuff
export HISTCONTROL="erasedups:ignoreboth"
export HISTFILESIZE=5000000
export HISTSIZE=1000000
# These will let you auto-complete from history in the .bash_history file, so if you already entered this command then use the up or down arrow to auto fill
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

shopt -s histappend
shopt -s cmdhist
shopt -s cdspell
shopt -s dotglob

#Setup for prompt
didCD=true
function didCDfun {
if $didCD ; then pwd; fi
didCD=false
}
export PROMPT_COMMAND="didCDfun"
export PS1=' \[\033[0;36m\][\t] $\[\e[0m\]'

alias pushd='didCD=true&&pushd'
alias popd='didCD=true&&popd'

alias ls='ls --color=always'
alias la='ls -Ahl'
alias dir='ls -lAF'

alias grep='grep --color=always'

alias del='rm -iP'
alias zap='rm -iP'
alias deltree='rm -rfd'
alias deltreesecure='rm -rfdP'

alias c='clear'
alias cls='clear'

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

#Common typos
alias gh='hg'
alias hgin='hg in'
***REMOVED***
alias cd..='cd ..'
alias idff='diff'


# use textmate
export EDITOR="/usr/local/bin/mate -w"



#    ____             _   _            
#   |  _ \           | | | |           
#   | |_) | ___ _ __ | |_| | ___ _   _ 
#   |  _ < / _ \ '_ \| __| |/ _ \ | | |
#   | |_) |  __/ | | | |_| |  __/ |_| |
#   |____/ \___|_| |_|\__|_|\___|\__, |
#                                 __/ |
#                                |___/ 


alias ntlm='python /Applications/ntlmaps-0.9.9.0.1/main.py'

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***

#sayno(){
#expect -c 'expect "Optimized Build? \[y|n\]" send n'
#}
 
***REMOVED***

alias openprojecta='gotoproject && . $IOSTAIL/openARM.sh'
alias openprojectx='gotoproject && . $IOSTAIL/openX86.sh'
alias opa='openprojecta'
alias opx='openprojectx'

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***



#acess project under team
***REMOVED***
***REMOVED***

***REMOVED***
alias openprojectold='gotoprojectold && . $IOSTAIL/openARM.sh'
