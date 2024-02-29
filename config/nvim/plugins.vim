set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdcommenter'
"Plug 'Yggdroot/indentLine'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-fugitive'

Plug 'godlygeek/tabular'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'elzr/vim-json'

Plug 'YanhaoYang/neodark.vim'

Plug 'neoclide/coc.nvim'
Plug 'yanhao-pro/vim-snippets'

Plug 'fatih/vim-go'
Plug 'jiangmiao/auto-pairs'

Plug 'phaazon/hop.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-tree.lua'

call plug#end()

