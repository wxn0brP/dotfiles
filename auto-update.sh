#!/usr/bin/env zsh

DOTFILES_DIR="$HOME/dotfiles"
UPDATE_SCRIPT="$DOTFILES_DIR/update.sh"
LAST_CHECK_FILE="/tmp/.dotfiles_last_check"

CHECK_INTERVAL=$((60 * 60))

check_dotfiles_update() {
  [[ ! -d "$DOTFILES_DIR/.git" ]] && return

  local last_check=0
  [[ -f "$LAST_CHECK_FILE" ]] && last_check=$(<"$LAST_CHECK_FILE")

  local now=$(date +%s)
  if (( now - last_check < CHECK_INTERVAL )); then
    return
  fi

  echo "$now" > "$LAST_CHECK_FILE"
  git -C "$DOTFILES_DIR" fetch --quiet

  local behind_count
  behind_count=$(git -C "$DOTFILES_DIR" rev-list --count HEAD..@{u} 2>/dev/null)

  if [[ "$behind_count" -gt 0 ]]; then
    echo "Updates available for dotfiles."
    read -q "REPLY?Do you want to update now? (y/n) "
    echo
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
      "$UPDATE_SCRIPT"
    fi
  fi
}

check_dotfiles_update
