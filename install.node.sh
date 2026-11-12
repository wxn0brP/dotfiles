#!/usr/bin/env zsh
set -euo pipefail

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

echo "[*] Installing Node.js (latest)..."

if ! (( $+commands[curl] )); then
	echo "[!] curl is required" >&2
	exit 2
fi

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
	echo "[*] Installing nvm..."
	curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

export NVM_DIR
source "$NVM_DIR/nvm.sh"

nvm install node
nvm alias default node
nvm use node
