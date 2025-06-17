#/bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

if [ ! -d "~/.zshrc"] then
    mv ~/.zshrc ~/.zshrc.dot.bak
    echo ".zshrc renamed to ~/.zshrc.dot.bak"
fi

cp .zshrc ~/.zshrc
cp .vars ~/.vars
cp -r .glob ~/.glob
cp -r .fastfetch ~/.fastfetch