export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
autoload -Uz vcs_info
autoload -U colors && colors

precmd(){
    vcs_info
}

function custom_prompt {
    PROMPT=""
#    PROMPT="%F{green}%n%f"
#    PROMPT+="@" # Separator @
#    PROMPT+="%F{green}%m"
    PROMPT+="%F{magenta}%~%f"

    if [[ "$newll" == "true" ]]; then
        PROMPT+="\n"
    else
        PROMPT+=" "
    fi

    PROMPT+="%F{red}\$ %f"
    echo -n $PROMPT
}

export newll=false
PROMPT='$(custom_prompt)'
source ~/.vars
