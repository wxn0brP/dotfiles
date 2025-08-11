#!/bin/zsh
set -e

log() {
    echo "[*] $1"
}

install_node() {
    if ! command -v nvm >/dev/null 2>&1; then
        log "Installing Node..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        source ~/.nvm/nvm.sh
        nvm install 24
        nvm use 24
        source ~/.zshrc
    else
        log "Node already installed, skipping..."
    fi
}

install_npm() {
    log "Installing npm packages..."
    npm i -g yarn
}

config_npm() {
    if [ ! -f "$HOME/.npmrc" ]; then
        cat > "$HOME/.npmrc" << EOF
init-author-name=wxn0brP
init-author-email=____________________
init-version=0.0.1
//registry.npmjs.org/:_authToken=________________
prefix=~/.npm-global
EOF
    else 
        log "NPM already configured, skipping..."
    fi
    if [ ! -d "$HOME/.npm-global" ]; then
        log "Creating .npm-global directory..."
        mkdir -p "$HOME/.npm-global"
    fi
}

config_yarn() {
    if [ ! -f "$HOME/.yarnrc" ]; then
        log "Configuring Yarn..."
        cat > "$HOME/.yarnrc" << EOF
ignore-engines true
nmHoistingLimits workspaces
nodeLinker node-modules
prefix "$HOME/.npm-global"
EOF
    else
        log "Yarn already configured, skipping..."
    fi
}

install_yarn() {
    yarn global add typescript tsc-alias
    yarn global add github:wxn0brP/suglite#dist
    yarn global add github:wxn0brP/ValtheraDB-cli#dist
}

show_help() {
    echo "Usage: ./install.sh [--step install|pkg]"
    exit 1
}

main() {
    local step="pkg"

    if [[ "$1" == "--step" && -n "$2" ]]; then
        step="$2"
    elif [[ -n "$1" ]]; then
        show_help
    fi

    case "$step" in
        install)
            install_node
            ;;
        pkg)
            config_npm
            config_yarn
            install_npm
            install_yarn
            ;;
        *)
            show_help
            ;;
    esac
}

main "$@"