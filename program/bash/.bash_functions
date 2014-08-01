nameterm()
{
echo -n -e "\033]0;$1\007"
}

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }
	
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}

function catt() { # Highlight whitespace on the terminal -- rolfwr
    local C=`printf '\033[0;36m'` R=`printf '\033[0m'`
    #cat "$@" | sed -e "s/      /${C}▹▹▹▹▹▹▹▹$R/g" -e "s/ /${C}·$R/g" -e "s/$/${C}⁋$R/"
    #cat "$@" | sed -e "s/ /${C}·$R/g" -e "s/\t/${C} ▹▹ $R/g" -e "s/$/${C}⁋$R/"
    cat "$@" | sed -e "s/ /${C}·$R/g" | expand | sed -e "s/ \( *\)/${C}▹\1$R/g" -e "s/$/${C}⁋$R/"
    #cat "$@" | sed -e "s/ /${C}.$R/g" | expand | sed -e "s/ \( *\)/${C}>\1$R/g" -e "s/$/${C}P$R/"
}