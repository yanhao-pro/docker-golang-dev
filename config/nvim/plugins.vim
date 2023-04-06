set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'Yggdroot/indentLine'

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

call plug#end()

