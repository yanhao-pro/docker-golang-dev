#!/bin/bash

set -e
set -x

if [[ -f $HOME/.nvm/nvm.sh ]]; then
  source $HOME/.nvm/nvm.sh
  nvm use $NODE_VERSION
fi

pwd=$(pwd)
nvim --headless -u $pwd/plugins.vim +PlugInstall +qa

cd ~/.config/nvim/plugged/coc.nvim && yarn install

mkdir -p $HOME/.config/coc/extensions
cd $HOME/.config/coc/extensions
yarn add coc-snippets

rm -fr /home/docker/.cache/yarn

nvim --headless -u $pwd/plugins.vim +GoUpdateBinaries +qa
