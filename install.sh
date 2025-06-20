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

install_plugins() {
  log "Installing plugins..."

  local autosuggestions_dir="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
  local syntax_dir="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

  [[ -d "$autosuggestions_dir" ]] || git clone https://github.com/zsh-users/zsh-autosuggestions "$autosuggestions_dir"
  [[ -d "$syntax_dir" ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$syntax_dir"
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