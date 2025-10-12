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
zstyle ':omz:update' mode auto
ZSH_CUSTOM_AUTOUPDATE_QUIET=true

precmd(){
    vcs_info
}

function custom_prompt {
    PROMPT=""

    if [[ "$USER" != "$expected_user" ]]; then
        PROMPT+="%F{yellow}%n%f@"
    fi
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
source ~/dotfiles/.vars
source ~/.vars

_viol_complete() {
    reply=($(viol --complete) $(ls))
}
compctl -K _viol_complete viol

alias uuu="yay --noconfirm"
export SUDO_EDITOR=kwrite

_ya_complete() {
    local LAST_ARG="${words[-1]}"
    if [[ ${#LAST_ARG} -lt 4 ]]; then # do not complete short names
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

br () {
    bun run "$@"
}
compdef _files br

[ -s "/home/ash/.bun/_bun" ] && source "/home/ash/.bun/_bun"

add_npm_bin_to_path() {
  local npm_bin="./node_modules/.bin"
  if [ -d "$npm_bin" ]; then
    export PATH="$npm_bin:$PATH"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd add_npm_bin_to_path
add_npm_bin_to_path
