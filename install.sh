#!/usr/bin/env zsh
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
		log "Plugin $plugin_name already installed, updating..."
		git -C "$plugin_dir" pull
	fi
}

install_plugins() {
	log "Installing plugins..."

	download_plugin "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
	download_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting"
	download_plugin "https://github.com/grigorii-zander/zsh-npm-scripts-autocomplete" "zsh-npm-scripts-autocomplete"
	download_plugin "https://github.com/Katrovsky/zsh-ollama-completion" "ollama"

	log "Installing bun completions..."
	curl -fsSL https://raw.githubusercontent.com/oven-sh/bun/HEAD/completions/bun.zsh > ~/.bun/bun.zsh
}

backup_and_copy_dotfiles() {
	log "Copying dotfiles..."

	if [ -f "$HOME/.zshrc" ]; then
		read "?Found .zshrc. Back it up and replace? (Y/n) "
		echo
		if [[ ! "$REPLY" =~ ^[Nn]$ ]]; then
			mv "$HOME/.zshrc" "$HOME/.zshrc.dot.bak-w"
			log ".zshrc renamed to .zshrc.dot.bak-w"
			echo "source ~/dotfiles/.zshrc" > "$HOME/.zshrc"
		fi
	else
		echo "source ~/dotfiles/.zshrc" > "$HOME/.zshrc"
	fi

	if [ -f "$HOME/.bashrc" ]; then
		read "?Found .bashrc. Back it up and replace? (Y/n) "
		echo
		if [[ ! "$REPLY" =~ ^[Nn]$ ]]; then
			mv "$HOME/.bashrc" "$HOME/.bashrc.dot.bak-w"
			log ".bashrc renamed to .bashrc.dot.bak-w"
			echo "source ~/dotfiles/.bashrc" > "$HOME/.bashrc"
		fi
	else
		echo "source ~/dotfiles/.bashrc" > "$HOME/.bashrc"
	fi

	mkdir -p ~/.ing
	mkdir -p ~/VioletArchive
	mkdir -p ~/.glob
	if [ ! -f ~/.vars ]; then
		printf "expected_user='%s'\n" "$USER" > ~/.vars
	fi
	chmod +x glob/*

	if [ -d ~/.fastfetch ]; then
		read "?.fastfetch exists. Overwrite with dotfiles config? (Y/n) "
		echo
		if [[ ! "$REPLY" =~ ^[Nn]$ ]]; then
			cp -r .fastfetch ~/.fastfetch
		fi
	else
		read "?Copy fastfetch config to ~/.fastfetch? (Y/n) "
		echo
		if [[ ! "$REPLY" =~ ^[Nn]$ ]]; then
			cp -r .fastfetch ~/.fastfetch
		fi
	fi

	read "?Enable auto-update checks on shell start? (Y/n) "
	echo
	if [[ "$REPLY" =~ ^[Nn]$ ]]; then
		echo 'export NO_DOTFILES_UPDATE=1' >> ~/.vars
		log "Auto-update disabled (NO_DOTFILES_UPDATE set in ~/.vars)"
	fi
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
