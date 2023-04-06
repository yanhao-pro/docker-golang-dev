#!/bin/bash

set -e
set -x

if [[ -f $HOME/.nvm/nvm.sh ]]; then
  source $HOME/.nvm/nvm.sh
  nvm use $NODE_VERSION
fi

nvim --headless -u ./plugins.vim +PlugInstall +qa
nvim --headless -u ./plugins.vim +GoUpdateBinaries +qa

cd ~/.config/nvim/plugged/coc.nvim && yarn install
mkdir -p $HOME/.config/coc/extensions && cd $HOME/.config/coc/extensions && yarn add coc-snippets
