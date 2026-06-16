#!/usr/bin/env zsh

cd $HOME/dotfiles
git pull
ingr

if [[ -z "$NO_DOTFILES_PLUGINS_UPDATE" ]]; then
    ./install.sh --step plugins
fi

echo "💜 Done!"
