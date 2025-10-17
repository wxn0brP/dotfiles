#!/bin/zsh
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

print_colored() {
    local color="$1"
    local text="$2"
    echo -e "${color}${text}${NC}"
}

clear_screen() {
    clear
    print_colored $CYAN "=========================================="
    print_colored $CYAN "       wxn0brP dotfiles setup script"
    print_colored $CYAN "=========================================="
    echo ""
}

wait_for_input() {
    read "?Press Enter to continue..."
}

execute_command() {
    local cmd="$1"
    local desc="$2"
    print_colored $YELLOW "Executing: $desc"
    print_colored $WHITE "$cmd"
    echo ""
    eval "$cmd"
    echo ""
    print_colored $GREEN "Completed: $desc"
    wait_for_input
}

main_menu() {
    while true; do
        clear_screen
        print_colored $WHITE "Select an option:"
        echo "1. Basic Setup"
        echo "2. Install Node.js"
        echo "3. Configure Node"
        echo "4. Install Bun"
        echo "5. Install tools"
        echo "6. Install missing dotfiles plugins"
        echo "0. Exit"
        echo ""
        read "?Select an option: " choice
        
        case $choice in
            1)
                execute_command "./install.sh" "Basic Setup"
                ;;
            2)
                execute_command "./install.node.sh --step install" "Install Node.js"
                ;;
            3)
                execute_command "./install.node.sh --step pkg" "Configure Node"
                ;;
            4)
                execute_command "curl -fsSL https://bun.sh/install | bash" "Install Bun"
                ;;
            5)
                execute_command "./install.ing.sh" "Install tools"
                ;;
            6)
                execute_command "./install.sh --step plugins" "Install missing dotfiles plugins"
                ;;
            0)
                print_colored $GREEN "Exiting..."
                exit 0
                ;;
            *)
                print_colored $RED "Invalid option. Please try again."
                wait_for_input
                ;;
        esac
    done
}

cd $HOME
if [ ! -d "dotfiles" ]; then
    print_colored $CYAN "Cloning dotfiles..."
    git clone https://github.com/wxn0brP/dotfiles.git
fi 
cd dotfiles
git pull
chmod +x ./install* 2>/dev/null || true

main_menu