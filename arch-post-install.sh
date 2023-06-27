sudo pacman -S git unzip neovim

#rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

mkdir ~/ws
cd ~/ws
# paru

git clone https://aur.archlinux.org/paru.git
cd ./paru
makepkg -si

cd ..

sudo paru -S lemurs-git

sudo systemctl enable lemurs.service

#neovim
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

ln -s /home/uri/ws/dotfiles/nvim/lua/custom /home/uri/.config/nvim/lua/custom

#volta
curl https://get.volta.sh | bash

volta install node

