function virtualenv_info {
    previous_exit=$?
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
    return previous_exit
}

function exit_smiley() {
    exit_status=`print -P "%?"`
    if [[ exit_status -eq 0 ]]; then
	echo "%{$fg_bold[green]%}:%)"
    else
	echo "%{$fg_bold[red]%}:( %s"
    fi
}

local ret_status="%(?,%{$fg_bold[green]%}:%) ,%{$fg_bold[red]%}:( %s)"
PROMPT="\$(virtualenv_info)%~ \$(exit_smiley)%{$reset_color%}"
RPROMPT='%{$reset_color%}%T %{$fg_bold[white]%} %n@%m%{$reset_color%}'

