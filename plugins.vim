set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')

Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'Yggdroot/indentLine'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-fugitive'

Plug 'godlygeek/tabular'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'elzr/vim-json'

Plug 'YanhaoYang/neodark.vim'

"Plug 'neoclide/coc.nvim'
"
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'yanhao-pro/vim-snippets'

Plug 'fatih/vim-go'
Plug 'jiangmiao/auto-pairs'

Plug 'phaazon/hop.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

