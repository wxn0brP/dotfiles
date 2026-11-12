#!/usr/bin/env zsh
set -euo pipefail

projects=(server suglite bumr lang-diff pressure domowik)
STTY_ORIG=""

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

show_help() {
	local project

	cat <<EOF
Usage: ./install.ing.sh [project...]

No arguments opens the interactive picker.

Projects:
EOF

	for project in "${projects[@]}"; do
		printf '  %s\n' "$project"
	done

	cat <<EOF

Options:
  -h, --help   Show this help
  all          Install every project

Examples:
  ./install.ing.sh
  ./install.ing.sh all
  ./install.ing.sh server domowik
EOF
}

cleanup_terminal() {
	stty "$STTY_ORIG" 2>/dev/null || true
	print -n '\e[?25h'
}

select_projects() {
	if [[ ! -t 0 || ! -t 1 ]]; then
		die "Interactive mode requires a terminal; pass project names or 'all'"
	fi

	local -a selected
	local cursor=1 key rest mark
	local i

	for _ in "${projects[@]}"; do
		selected+=(1)
	done

	STTY_ORIG=$(stty -g)
	trap 'cleanup_terminal' EXIT
	trap 'cleanup_terminal; exit 130' INT TERM
	stty -icanon -echo

	while true; do
		clear
		print -n '\e[2J\e[H\e[?25l'

		print "=== Install Tools ==="
		print "up/down or j/k navigate, space toggle, enter confirm, q quit"
		print

		for (( i = 1; i <= ${#projects}; i++ )); do
			mark="[ ]"
			if (( selected[i] )); then
				mark="[✓]"
			fi

			if (( i == cursor )); then
				print -r -- "\e[7m> $mark ${projects[i]}\e[0m"
			else
				print -r -- "  $mark ${projects[i]}"
			fi
		done

		print
		read -k 1 key

		case "$key" in
			$'\e')
				read -k 2 rest
				case "$rest" in
					'[A')
						if (( cursor > 1 )); then
							(( cursor-- ))
						fi
					;;
					'[B')
						if (( cursor < ${#projects} )); then
							(( cursor++ ))
						fi
					;;
				esac
			;;
			' ')
				selected[cursor]=$(( 1 - selected[cursor] ))
			;;
			'j')
				if (( cursor < ${#projects} )); then
					(( cursor++ ))
				fi
			;;
			'k')
				if (( cursor > 1 )); then
					(( cursor-- ))
				fi
			;;
			$'\n' | $'\r')
				break
			;;
			'q' | 'Q')
				cleanup_terminal
				trap - EXIT INT TERM
				clear
				print "Installation cancelled."
				exit 0
			;;
		esac
	done

	cleanup_terminal
	trap - EXIT INT TERM
	clear

	chosen=()
	for (( i = 1; i <= ${#projects}; i++ )); do
		if (( selected[i] )); then
			chosen+=("${projects[i]}")
		fi
	done
}

install_projects() {
	local project failures=0

	if ! (( $+commands[ingr.ts] )); then
		die "ingr.ts not found in PATH"
	fi

	print
	log "Installing selected projects..."

	for project in "$@"; do
		print
		print ">>> Installing $project..."
		if ! ingr.ts "$project"; then
			warn "Failed: $project"
			failures=$(( failures + 1 ))
		fi
	done

	print
	if (( failures )); then
		warn "$failures project(s) failed"
		exit 1
	fi
	print "Done!"
}

main() {
	local -a chosen=()
	local arg

	if (( $# == 0 )); then
		select_projects
	else
		while (( $# )); do
			arg="$1"

			case "$arg" in
				-h | --help)
					show_help
					exit 0
				;;
				all)
					chosen+=("${projects[@]}")
				;;
				-*)
					die "Unknown option: $arg"
				;;
				*)
					if [[ " ${projects[*]} " != *" $arg "* ]]; then
						die "Unknown project: $arg"
					fi

					chosen+=("$arg")
				;;
			esac

			shift
		done
	fi

	if (( ! ${#chosen} )); then
		log "Nothing selected."
		exit 0
	fi

	chosen=("${(@u)chosen}")
	install_projects "${chosen[@]}"
}

main "$@"
