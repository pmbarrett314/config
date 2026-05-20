autoload -U colors && colors
setopt PROMPT_SUBST

typeset -g LAST_EXIT=0

function virtualenv_info() {
    previous_exit=$?
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
    return previous_exit
}

function precmd() {
    LAST_EXIT=$?
    print -n -P "%{$fg_bold[magenta]%}"
    if [[ "$DID_CD" == true ]]; then
        pwd
    fi
    print -n -P "%{$reset_color%}"
    DID_CD=false
}

function exit_smiley() {
    if (( LAST_EXIT == 0 )); then
        echo "%{$fg_bold[green]%}:%)"
    else
	   echo "%{$fg_bold[red]%}:( ($LAST_EXIT)"
    fi
}

DID_CD=true



function chpwd() {
    DID_CD=true
}

PROMPT="\$(virtualenv_info)%{$fg_bold[cyan]%}[%*]%{$reset_color%} \$(exit_smiley)%{$reset_color%} %{$fg[cyan]%}%#%{$reset_color%}"
RPROMPT='%{$reset_color%}%{$fg_bold[white]%} %n@%m%{$reset_color%}'
