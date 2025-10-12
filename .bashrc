#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

prompt_path() {
    local MAX_LENGTH=20
    local PWD_PATH="${PWD/#$HOME/\~}"

    if (( ${#PWD_PATH} > MAX_LENGTH )); then
        local PART1=$(echo "$PWD_PATH" | awk -F '/' '{print $1"/"$2"/.../"$(NF-1)}')
        local PART2=$(basename "$PWD_PATH")
        PWD_PATH="$PART1/$PART2"
    fi

    echo "$PWD_PATH"
}

RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
CYAN="\[\033[0;36m\]"
PURPLE="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
LIGHT_GRAY="\[\033[0;37m\]"
DARK_GRAY="\[\033[1;30m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_BLUE="\[\033[1;34m\]"
LIGHT_CYAN="\[\033[1;36m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
LIGHT_YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
NO_COLOR="\[\033[0m\]"

PS1="${BLUE}\u${NO_COLOR}@${LIGHT_GREEN}\h ${YELLOW}\$(prompt_path) ${RED}\$${NO_COLOR} "

source ~/dotfiles/.vars
source ~/.vars
