#!/usr/bin/env zsh

projects=(server suglite bumr lang-diff pressure domowik)
selected=(1 1 1 1 1 1)

while true; do
	echo ""
	echo "=== Install Tools ==="
	echo ""
	for i in {1..$#projects}; do
		mark="[ ]"
		[[ $selected[$i] -eq 1 ]] && mark="[x]"
		echo "  $i. $mark $projects[$i]"
	done
	echo ""
	echo "  a. Install all selected"
	echo "  q. Quit"
	echo ""
	read "?Toggle number, or a/q: " choice

	case $choice in
		a|A)
			break
			;;
		q|Q)
			echo "Installation cancelled."
			exit 0
			;;
		*)
			if [[ $choice =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le $#projects ]]; then
				selected[$choice]=$(( 1 - selected[$choice] ))
			else
				echo "Invalid choice."
			fi
			;;
	esac
done

echo ""
echo "Installing selected projects..."
for i in {1..$#projects}; do
	if [[ $selected[$i] -eq 1 ]]; then
		echo ""
		echo ">>> Installing ${projects[$i]}..."
		ingr "${projects[$i]}"
	fi
done
echo ""
echo "Done!"
