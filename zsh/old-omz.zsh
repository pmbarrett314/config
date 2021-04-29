if [ ! -n "${SKIP_OH_MY_GIT+x}" ]; then
	function virtualenv_info() {
		previous_exit=$?
		[ $VIRTUAL_ENV ] && echo '('$(basename $VIRTUAL_ENV)') '
		return previous_exit
	}

	function exit_smiley() {
		exit_status=$(print -P "%?")
		if [[ exit_status -eq 0 ]]; then
			echo "%{$fg_bold[green]%}:%)"
		else
			echo "%{$fg_bold[red]%}:("
		fi
	}

	DID_CD=true

	function precmd() {
		print -n -P "%{$fg_bold[magenta]%}"
		if "$DID_CD"; then
			pwd
		fi
		print -n -P "%{$reset_color%}"
		DID_CD=false
	}

	function chpwd() {
		DID_CD=true
	}

	local ret_status="%(?,%{$fg_bold[green]%}:%) ,%{$fg_bold[red]%}:( %s)"
	omg_ungit_prompt="\$(virtualenv_info)%{$fg_bold[cyan]%}[%*]%{$reset_color%} \$(exit_smiley)%{$reset_color%} %{$fg[cyan]%}%#%{$reset_color%}"
	omg_second_line="\$(virtualenv_info)%{$fg_bold[cyan]%}[%*]%{$reset_color%} \$(exit_smiley)%{$reset_color%} %{$fg[cyan]%}%#%{$reset_color%}"

	VIRTUAL_ENV_DISABLE_PROMPT=true
	function omg_prompt_callback() {
		if [ -n "${VIRTUAL_ENV}" ]; then
			echo "\e[0;31m($(basename ${VIRTUAL_ENV}))\e[0m "
		fi
	}

	antigen-bundle arialdomartini/oh-my-git
	antigen theme arialdomartini/oh-my-git-themes oppa-lana-style
	RPROMPT='%{$reset_color%}%{$fg_bold[white]%} %n@%m%{$reset_color%}'
else
	antigen theme $PERSONAL_CONFIG_DIR/zsh --no-local-clone
fi
