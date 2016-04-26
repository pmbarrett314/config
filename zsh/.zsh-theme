function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

local ret_status="%(?,%{$fg_bold[green]%}:%) ,%{$fg_bold[red]%}:( %s)"
PROMPT="\$(virtualenv_info)%~ ${ret_status}%{$reset_color%}"
RPROMPT='%{$reset_color%}%T %{$fg_bold[white]%} %n@%m%{$reset_color%}'
