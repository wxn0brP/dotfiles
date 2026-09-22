#!/usr/bin/env zsh

projects=(server suglite bumr lang-diff pressure domowik)
selected=(1 1 1 1 1 1)
cursor=1

stty_orig=$(stty -g)
cleanup() {
	stty $stty_orig
	echo -ne '\e[?25h'
}
trap cleanup EXIT INT TERM

stty -icanon -echo

while true; do
	clear
	echo -ne '\e[2J\e[H'
	echo -ne '\e[?25l'
	
	echo "=== Install Tools ==="
	echo "up/down navigate, space toggle, enter confirm, q quit"
	echo ""
	
	for i in {1..$#projects}; do
		mark="[ ]"
		[[ $selected[$i] -eq 1 ]] && mark="[✓]"
		
		if [[ $i -eq $cursor ]]; then
			echo -e "\e[7m> $mark ${projects[$i]}\e[0m"
		else
			echo "  $mark ${projects[$i]}"
		fi
	done
	
	echo ""
	
	read -k 1 key
	case $key in
		$'\e')
			read -k 2 rest
			case $rest in
				'[A')
					((cursor > 1)) && ((cursor--))
					;;
				'[B')
					((cursor < $#projects)) && ((cursor++))
					;;
			esac
			;;
		' ')
			selected[$cursor]=$(( 1 - selected[$cursor] ))
			;;
		$'\n')
			break
			;;
		'q'|'Q')
			echo -ne '\e[2J\e[H'
			echo "Installation cancelled."
			exit 0
			;;
	esac
done

clear

echo ""
echo "Installing selected projects..."
for i in {1..$#projects}; do
	if [[ $selected[$i] -eq 1 ]]; then
		echo ""
		echo ">>> Installing ${projects[$i]}..."
		command ingr.ts "${projects[$i]}"
	fi
done
echo ""
echo "Done!"
