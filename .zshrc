export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
  git
  z
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-npm-scripts-autocomplete
  ollama
)
source $ZSH/oh-my-zsh.sh
fpath=(~/.oh-my-zsh/custom/completions $fpath)
autoload -Uz vcs_info
autoload -Uz colors && colors
autoload -Uz compinit && compinit

precmd(){
    vcs_info
}

function custom_prompt {
    PROMPT=""

    if [[ -n "$SSH_CONNECTION" ]]; then
        PROMPT+="%F{cyan}%m%f "
    fi

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

_viol_complete() {
    reply=($(viol --complete) $(ls))
}
compctl -K _viol_complete viol

alias uuu="yay --noconfirm"
export SUDO_EDITOR=kwrite

_ya_complete() {
    local LAST_ARG="${words[-1]}"
    if [[ ${#LAST_ARG} -lt 5 ]]; then # do not complete short names
        reply=()
        return
    fi
    local DATA=$(all-the-package-names | grep -- "$LAST_ARG")
    reply=(${(f)DATA})
}

ya () {
    yarn add "$@"
}
compctl -K _ya_complete ya
