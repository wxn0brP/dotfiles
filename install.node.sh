#!/usr/bin/env zsh
set -e

if [ -d "$HOME/.nvm" ]; then
    log "Node already installed"
    exit 0
fi

echo "[*] Installing Node..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 25
nvm use 25
source ~/.zshrc
