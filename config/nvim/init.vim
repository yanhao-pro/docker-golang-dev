set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc

call plug#begin('~/.config/nvim/plugged')
Plug 'phaazon/hop.nvim'
call plug#end()

lua require'hop'.setup()

noremap <leader>w :HopWord<CR>
