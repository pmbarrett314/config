# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#grep aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


alias cdir='cd "$@" && dir .'

#alias .="pwd"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias ~="cd ~"

# some more ls aliases
# A is all but . and .. mac/cyg/rpiarch
# G is color on mac, 
# G is no group in long format cyg/rpiarch
# --color=always is color on cyg/rpiarch
# l is long format mac/cyg/rpiarch
# h is human readble with binary prefixes (K is kibibyte, etc.) mac/cyg/rpiarch
# F displays characters to show filetype (classify) mac/cyg/rpiarch
# C is multi column, default behavior mac/cyg/rpi
# T goes with l to show complete time to second mac
# T does tabsize on cyg/rpiarch
# --time-style is similar on cyg/rpiarch

if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls='ls -G'
	alias dir='ls -lAFT'
else
	alias dir='ls -lAF'
fi

if [[ "$OSTYPE" == "linux-gnu"*]]||[[ "$OSTYPE" == "cygwin"]]; then
	alias ls='ls --color=auto'
fi

alias ll='ls -AlF'
alias la='ls -Ahl'
alias l='ls -CF'



# deletions
# d removes directories as well as other types of files mac
# d removes empty directories rpiarch
# no d on cygwin, use R/r instead 
# r/R removes file hierarchy, implies d mac/cyg/rpiarch
# i asks for confirmation before each file mac/cyg/rpiarch
# P does secure delete, overwrite with FF,00,FF mac
# use shred for this on cyg/arch
# f tries to remove without prompt, regardless of permissions or whether the file exits mac
# f changes permissions if necessary rpiarch
# f ignores nonexistent and never prompts cyg
if [[ "$OSTYPE" == "darwin"* ]]; then
	alias del='rm -iP'
	alias zap='rm -iP'
	alias deltree='rm -rfd'
	alias deltreesecure='rm -rfPd'
fi

if [[ "$OSTYPE" == "linux-gnu"*]]||[[ "$OSTYPE" == "cygwin"]]; then
	alias del='rm -i'
	alias zap='rm -i'
	alias deltree='rm -rf'
	alias deltreesecure='rm -rf'
fi

if [[ "$OSTYPE" == "linux-gnu"*] ]]; then
	alias deltree='rm -rfd'
	alias deltreesecure='rm -rfPd'
fi

#clears and prints a line
alias c='clear&&pwd&&printf "%*s\n" "${COLUMNS:-$(tput cols)}" "" | tr " " -'
alias cls='clear&&pwd&&printf "%*s\n" "${COLUMNS:-$(tput cols)}" "" | tr " " -'


#typos
alias cd..='cd ..'
alias idff='diff'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


#alias stats='history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n$@''