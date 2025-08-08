gcl https://github.com/neovim/neovim.git
cd neovim
brew install ninja cmake gettext curl
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

cp -rv config/nvim ~/.config
nvim --headless +GoInstallBinaries +qa
