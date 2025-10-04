#!/bin/zsh
set -e

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

log() {
  echo "[*] $1"
}

install_ohmyzsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    log "Oh My Zsh already installed, skipping..."
  fi
}

download_plugin() {
  local repo_url="$1"
  local plugin_name="$2"
  local plugin_dir="${ZSH_CUSTOM}/plugins/${plugin_name}"

  if [ ! -d "$plugin_dir" ]; then
    log "Installing plugin: $plugin_name"
    git clone "$repo_url" "$plugin_dir"
  else
    log "Plugin $plugin_name already installed, skipping..."
  fi
}

install_plugins() {
  log "Installing plugins..."

  download_plugin "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
  download_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting"
  download_plugin "https://github.com/grigorii-zander/zsh-npm-scripts-autocomplete" "zsh-npm-scripts-autocomplete"
  download_plugin "https://github.com/Katrovsky/zsh-ollama-completion" "ollama"
}

backup_and_copy_dotfiles() {
  log "Copying dotfiles..."

  if [ -f "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.dot.bak"
    log ".zshrc renamed to .zshrc.dot.bak"
  fi

  cp .zshrc ~/.zshrc
  cp .vars ~/.vars
  cp -r .glob ~/.glob
  chmod +x ~/.glob/*
  cp -r .fastfetch ~/.fastfetch
}

show_help() {
  echo "Usage: ./install.sh [--step install|plugins|dotfiles|all]"
  exit 1
}

main() {
  local step="all"

  if [[ "$1" == "--step" && -n "$2" ]]; then
    step="$2"
  elif [[ -n "$1" ]]; then
    show_help
  fi

  case "$step" in
    install)
      install_ohmyzsh
      ;;
    plugins)
      install_plugins
      ;;
    dotfiles)
      backup_and_copy_dotfiles
      ;;
    all)
      install_ohmyzsh
      install_plugins
      backup_and_copy_dotfiles
      ;;
    *)
      show_help
      ;;
  esac
}

main "$@"