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

# some more ls aliases
alias ls='ls -G'
alias ll='ls -lF'
#alias ll='ls -alF'
alias la='ls -Ahl'
alias l='ls -CF'
alias dir='ls -lAF'
#alias dir='ls -lAFT'

# deletions
alias del='rm -iP'
alias zap='rm -iP'
alias deltree='rm -rf'
alias deltreesecure='rm -rfP'
#alias deltree='rm -rfd'
#alias deltreesecure='rm -rfdP'

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