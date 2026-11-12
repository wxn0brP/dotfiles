#!/usr/bin/env zsh
set -euo pipefail

DOTFILES_DIR="${0:A:h}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ASSUME_YES=0

log() {
	print -r -- "[*] $*"
}

warn() {
	print -ru2 -- "[!] $*"
}

die() {
	warn "$*"
	exit 2
}

confirm() {
	local question="$1"
	local default="${2:-y}"
	local reply

	if (( ASSUME_YES )) || [[ ! -t 0 ]]; then
		[[ "$default" == "y" ]]
		return
	fi

	read "reply?$question " || return 1
	reply="${reply:-$default}"
	[[ "$reply" == [Yy]* ]]
}

install_ohmyzsh() {
	if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
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

	mkdir -p "$ZSH_CUSTOM/plugins"

	if [[ ! -d "$plugin_dir" ]]; then
		log "Installing plugin: $plugin_name"
		git clone "$repo_url" "$plugin_dir"
	else
		log "Plugin $plugin_name already installed, updating..."
		git -C "$plugin_dir" pull
	fi
}

install_plugins() {
	if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
		warn "Oh My Zsh not found. Run: ./install.sh omz"
	fi

	log "Installing plugins..."

	download_plugin "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
	download_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting"
	download_plugin "https://github.com/grigorii-zander/zsh-npm-scripts-autocomplete" "zsh-npm-scripts-autocomplete"
	download_plugin "https://github.com/Katrovsky/zsh-ollama-completion" "ollama"
	download_plugin "https://github.com/MichaelAquilina/zsh-you-should-use" "zsh-you-should-use"
	download_plugin "https://github.com/Aloxaf/fzf-tab" "fzf-tab"
	download_plugin "https://github.com/wfxr/forgit.git" "forgit"

	log "Installing bun completions..."
	mkdir -p "$HOME/.bun"
	curl -fsSL https://raw.githubusercontent.com/oven-sh/bun/HEAD/completions/bun.zsh > "$HOME/.bun/bun.zsh"
}

install_rc() {
	local rc="$1"
	local target="$HOME/$rc"
	local backup="$target.dot.bak-w"

	if [[ -f "$target" ]]; then
		confirm "Found $rc. Back it up and replace?" y || return 0

		if [[ -e "$backup" ]]; then
			backup="$backup-$(date +%s)"
		fi

		mv "$target" "$backup"
		log "$rc renamed to ${backup##*/}"
	fi

	printf 'source %s/%s\n' "$DOTFILES_DIR" "$rc" > "$target"
}

backup_and_copy_dotfiles() {
	cd "$DOTFILES_DIR"
	log "Copying dotfiles..."

	install_rc .zshrc
	install_rc .bashrc

	mkdir -p "$HOME/.ing" "$HOME/VioletArchive" "$HOME/.glob"

	if [[ ! -f "$HOME/.vars" ]]; then
		printf "expected_user='%s'\n" "$USER" > "$HOME/.vars"
	fi

	if [[ -d "$DOTFILES_DIR/glob" ]]; then
		chmod +x "$DOTFILES_DIR"/glob/*
	fi

	if [[ -d "$HOME/.fastfetch" ]]; then
		if confirm ".fastfetch exists. Overwrite with dotfiles config?" y; then
			cp -r "$DOTFILES_DIR/.fastfetch/." "$HOME/.fastfetch/"
		fi
	elif confirm "Copy fastfetch config to ~/.fastfetch?" y; then
		cp -r "$DOTFILES_DIR/.fastfetch" "$HOME/.fastfetch"
	fi

	if ! confirm "Enable auto-update checks on shell start?" y; then
		if ! grep -q "NO_DOTFILES_UPDATE" "$HOME/.vars"; then
			echo 'export NO_DOTFILES_UPDATE=1' >> "$HOME/.vars"
		fi
		log "Auto-update disabled (NO_DOTFILES_UPDATE set in ~/.vars)"
	fi
}

typeset -A STEP_FN=(
	omz      install_ohmyzsh
	plugins  install_plugins
	dotfiles backup_and_copy_dotfiles
)
typeset -a STEP_ORDER=(omz plugins dotfiles)
typeset -A STEP_DESC=(
	omz      "install Oh My Zsh"
	plugins  "install/update zsh plugins and bun completions"
	dotfiles "back up shell rc files and copy dotfiles"
)
typeset -A STEP_ALIAS=(
	install omz
	ohmyzsh omz
	zsh     omz
)

resolve_step() {
	local name="${STEP_ALIAS[$1]:-$1}"

	if [[ -z "${STEP_FN[$name]:-}" ]]; then
		warn "Unknown step: $1"
		warn "Available: ${(j:, :)STEP_ORDER} (or 'all')"
		exit 2
	fi

	print -r -- "$name"
}

show_help() {
	local step

	cat <<EOF
Usage: ./install.sh [options] [step...]

Steps:
EOF

	for step in "${STEP_ORDER[@]}"; do
		printf '  %-10s %s\n' "$step" "${STEP_DESC[$step]}"
	done

	cat <<EOF

Aliases:
  install, ohmyzsh, zsh -> omz
  all                   -> every step, in order (default)

Options:
  -h, --help   Show this help
  -y, --yes    Accept defaults without prompting
  --step NAME  Legacy form, same as 'install.sh NAME'

Examples:
  ./install.sh                     # everything, interactively
  ./install.sh plugins             # only zsh plugins
  ./install.sh install plugins -y  # omz + plugins, no prompts
  ./install.sh --step dotfiles     # legacy form
EOF
}

main() {
	local -a steps=()
	local arg step

	while (( $# )); do
		arg="$1"

		case "$arg" in
			-h | --help)
				show_help
				exit 0
			;;
			-y | --yes)
				ASSUME_YES=1
			;;
			--step)
				[[ -n "${2:-}" ]] || die "--step requires a step name"
				steps+=("$(resolve_step "$2")")
				shift
			;;
			all)
				steps+=("${STEP_ORDER[@]}")
			;;
			-*)
				die "Unknown option: $arg"
			;;
			*)
				steps+=("$(resolve_step "$arg")")
			;;
		esac

		shift
	done

	(( ${#steps} )) || steps=("${STEP_ORDER[@]}")
	steps=("${(@u)steps}")

	for step in "${steps[@]}"; do
		log "Step '$step': ${STEP_DESC[$step]}"
		"${STEP_FN[$step]}"
	done
}

main "$@"
