#!/bin/bash

if [[ -f $HOME/.nvm/nvm.sh ]]; then
  source $HOME/.nvm/nvm.sh
  nvm use $NODE_VERSION
fi

if [[ ! -d bundle/coc.nvim ]]; then
  mkdir -p $HOME/.config/coc
  git clone https://github.com/neoclide/coc.nvim.git bundle/coc.nvim
  cd bundle/coc.nvim && yarn install
  mkdir -p $HOME/.config/coc/extensions && cd $HOME/.config/coc/extensions && yarn add coc-snippets
  cd ~/.vim
fi

[[ -d bundle/Vundle.vim ]] || git clone https://github.com/VundleVim/Vundle.vim.git bundle/Vundle.vim
vim --not-a-term -u ./plugins +BundleInstall +qa
vim --not-a-term -c "execute 'silent GoUpdateBinaries' | execute 'quit'"
