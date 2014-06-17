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


# some more ls aliases
# A is all but . and .. mac/cyg
# G is color on mac, not cyg
# l is long format mac
# F displays characters to show filetype mac
# C is multi column, default behavior mac/cyg
# T goes with l to show complete time to second mac

alias ls='ls -G'
alias ll='ls -AlF'
alias la='ls -Ahl'
alias l='ls -CF'
alias dir='ls -lAF'
#alias dir='ls -lAFT'

# deletions
#d removes directories as well as other types of files mac
#r/R removes file hierarchy, implies d mac
#i asks for confirmation before each file
#P does secure delete, overwrite with FF,00,FF mac
alias del='rm -iP'
alias zap='rm -iP'
alias deltree='rm -rfd'
alias deltreesecure='rm -rfPd'

#clearing
alias c='clear&&pwd'
alias cls='clear&&pwd'


#typos
alias gh='hg'
alias hgin='hg in'
alias cd..='cd ..'
alias idff='diff'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'