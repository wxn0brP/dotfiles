#!/usr/bin/env zsh

cd $HOME/dotfiles
git pull
./install.sh --step plugins
./install.ing.sh
ingr

echo "💜 Done!"