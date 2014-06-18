alias bp='open ~/.bash_profile -W && source ~/.bash_profile'

# this customizes the prompt - remove the \n to make the cursor to be on the same line

# sets the title
echo -n -e "\033]0;Default Prompt\007"

#keep more history stuff
export HISTCONTROL="erasedups:ignoreboth"
export HISTFILESIZE=5000000
export HISTSIZE=1000000
# These will let you auto-complete from history in the .bash_history file, so if you already entered this command then use the up or down arrow to auto fill

shopt -s histappend
shopt -s cmdhist
shopt -s cdspell
shopt -s dotglob

#Setup for prompt
if [ -f ~/Code/stuff/byProgram/bash/.bash_myprompt ]; then
   . ~/Code/stuff/byProgram/bash/.bash_myprompt
fi

if [ -f ~/Code/stuff/byProgram/bash/.bash_stack ]; then
   . ~/Code/stuff/byProgram/bash/.bash_stack
fi

if [ -f ~/Code/stuff/byProgram/bash/.bash_aliases ]; then
   . ~/Code/stuff/byProgram/bash/.bash_aliases
fi

***REMOVED***
***REMOVED***
fi

if [ -f ~/Code/stuff/byProgram/bash/.bash_functions ]; then
   . ~/Code/stuff/byProgram/bash/.bash_functions
fi


alias showfiles='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'





alias safari='open -a Safari'
alias itunes='open -a iTunes'


# use textmate
export EDITOR="/usr/local/bin/mate -w"
alias edit='open -a /usr/local/bin/mate'
