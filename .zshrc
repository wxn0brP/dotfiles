export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
autoload -Uz vcs_info

precmd(){
    vcs_info
}

function custom_prompt {
    PROMPT="%F{blue}%n%f"
    PROMPT+="@" # Separator @
    PROMPT+="%F{green}%m"
    PROMPT+="%F{blue} %~%f"
    PROMPT+="%F{red} \$ %f"
    echo -n $PROMPT
}

PROMPT='$(custom_prompt)'
source ~/.vars
