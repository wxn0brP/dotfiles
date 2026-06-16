#!/usr/bin/env zsh

function install() {
    local name=$1
    local script=$2
    echo "Installing $name..."
    curl -fsSL "https://raw.githubusercontent.com/wxn0brP/$name/HEAD/$script" | zsh
    echo ""
}

declare -A apps
apps=(
    [Zhiva]="install/prepare.sh"
)

# Non-interactive mode (when arguments are provided)
if (( $# > 0 )); then
    if [[ " $@ " =~ " all " ]]; then
        echo "Installing all recommended applications..."
        for app_name in "${(@k)apps}"; do
            install "$app_name" "${apps[$app_name]}"
        done
        echo "All applications installed."
    else
        echo "Installing selected applications..."
        for arg in "$@"; do
            if [[ -v "apps[$arg]" ]]; then
                install "$arg" "${apps[$arg]}"
            else
                echo "Error: Unknown application '$arg'. Available apps are: ${(@k)apps}"
            fi
        done
    fi
# Interactive mode (no arguments)
else
    echo "No arguments provided, entering interactive mode..."
    local -a options_list
    options_list+=("Install All")
    # Safely add app names to the list
    for app_name in ${(k)apps}; do
        options_list+=("$app_name")
    done
    options_list+=("Quit")

    while true; do
        echo "
Please choose an option:"
        i=1
        for item in "${options_list[@]}"; do
            echo "  $i) $item"
            ((i++))
        done

        read -r "REPLY?Type a number or 'q' to quit: "
        # Check for 'q' to quit
        if [[ "$REPLY" == "q" ]]; then
            echo "Exiting."
            break
        fi

        # Check if input is a valid number within the range of the options list
        if [[ "$REPLY" =~ ^[0-9]+$ ]] && [[ "$REPLY" -ge 1 ]] && [[ "$REPLY" -le ${#options_list[@]} ]]; then
            local choice="${options_list[$REPLY]}"
            case $choice in
                "Install All")
                    echo "Installing all recommended applications..."
                    for app_name in "${(@k)apps}"; do
                        install "$app_name" "${apps[$app_name]}"
                    done
                    echo "All applications installed."
                    break # Exit after installing all
                    ;;
                "Quit")
                    echo "Exiting."
                    break
                    ;;
                *)
                    install "$choice" "${apps[$choice]}"
                    echo "Installation of '$choice' complete. You can select another app or quit."
                    ;;
            esac
        else
            echo "Invalid selection: '$REPLY'. Please enter a number from the list."
        fi
    done
fi
