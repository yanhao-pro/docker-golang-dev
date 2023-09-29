source ~/.config/nvim/plugins.vim

filetype on
filetype plugin indent on   " Automatically detect file types.
syntax off                   " syntax highlighting

" Misc plugin settings {{{
let g:NERDDefaultAlign = 'left'

let g:vim_json_syntax_conceal = 0

let g:neodark#use_256color = 1
let g:neodark#terminal_transparent = 1
colorscheme neodark
" }}}

set encoding=utf-8

set wrap
set showbreak=...
set spell                       " spell checking on
set hidden                      " allow buffer switching without saving

set showmode                    " display the current mode

set redrawtime=10000            " fix timeout

if has('cmdline_info')
  set ruler                   " show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
  set showcmd                 " show partial commands in status line and
endif

if has('statusline')
  set laststatus=2

  set statusline=%<%f\    " Filename
  set statusline+=%w%h%m%r " Options
  set statusline+=\ [%{&ff}/%Y]            " filetype
  " set statusline+=%{fugitive#statusline()} "  Git Hotness
  " set statusline+=\ [%{getcwd()}]          " current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set showmatch                   " show matching brackets/parenthesis
set incsearch                   " find as you type search
set hlsearch                    " highlight search terms
set winminheight=0              " windows can be 0 line high
set ignorecase                  " case insensitive search
set smartcase                   " case sensitive when uc present
set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
set scrolljump=5                " lines to scroll when cursor leaves screen
set scrolloff=3                 " minimum lines to keep above and below cursor
set foldenable                  " auto fold code
set foldmethod=indent
set foldcolumn=2
set foldlevel=1
set list
set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace

set wildmenu                    " show list instead of just completing
set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
set wildignore=*.o,*.obj,*~     "stuff to ignore when tab completing
set wildignore+=*.so,*.swp,*.zip

set autoindent                  " indent at the same level of the previous line
set smarttab
set shiftwidth=2                " use indents of 4 spaces
set expandtab                   " tabs are spaces, not tabs
set tabstop=2                   " an indentation every four columns
set softtabstop=2               " let backspace delete indent
set pastetoggle=<F8>            " pastetoggle (sane indentation on pastes)

set autowrite
augroup AutoWrite
  autocmd! BufLeave * :update
augroup END

highlight ColorColumn ctermbg=235 guibg=#2c2d27
let &colorcolumn="80,100,".join(range(120,999),",")

" fix crontab: temp file must be edited in place
set backupskip=/tmp/*,/private/tmp/*

" Remove trailing whitespaces and ^M chars
autocmd BufWritePre * :%s/\s\+$//e

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

let mapleader = ","
let g:mapleader = ","

" Fast saving
map <leader>w :w<CR>
imap <leader>w <ESC>:w<CR>
vmap <leader>w <ESC><ESC>:w<CR>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" NerdTree {
map <leader>e :NERDTreeToggle<CR>
nmap <leader>nt :NERDTreeFind<CR>
nnoremap <silent> <C-f> :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.DS_Store']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
" }

" FZF {
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
nmap <leader>f :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>m :Marks<CR>
" }

map <C-q> :q<CR>
map <C-x> :wqa<CR>

function! InitializeDirectories()
  let separator = "."
  let parent = $HOME
  let prefix = '.vim'
  let dir_list = {
        \ 'backup': 'backupdir',
        \ 'views': 'viewdir',
        \ 'swap': 'directory' }

  if has('persistent_undo')
    let dir_list['undo'] = 'undodir'
  endif

  for [dirname, settingname] in items(dir_list)
    let directory = parent . '/' . prefix . dirname . "/"
    if exists("*mkdir")
      if !isdirectory(directory)
        call mkdir(directory)
      endif
    endif
    if !isdirectory(directory)
      echo "Warning: Unable to create backup directory: " . directory
      echo "Try: mkdir -p " . directory
    else
      let directory = substitute(directory, " ", "\\\\ ", "g")
      exec "set " . settingname . "=" . directory
    endif
  endfor
endfunction
call InitializeDirectories()

autocmd BufNewFile,BufRead *.{md,mkdn,markdown} set filetype=markdown

nmap <Leader>pm :PreviewMarkdown<CR>
nmap <Leader>pt :PreviewTextile<CR>
nmap <Leader>pr :PreviewRdoc<CR>
nmap <Leader>ph :PreviewHtml<CR>

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

nnoremap gw :Ag <C-R><C-W><CR>
nnoremap gr :grep <cword> --ignore-dir public<CR>
nnoremap Gr :grep <cword> %:p:h/*<CR>
nnoremap gR :grep '\b<cword>\b'<CR>
nnoremap GR :grep '\b<cword>\b' %:p:h/*<CR>
nnoremap gs :%s/\<<C-r><C-w>\>/

nnoremap gb :Git blame<CR>
nnoremap gl :%!xmllint --format -<CR>
nnoremap gp :PreviewMarkdown<CR>

" https://github.com/wincent/clipper
nnoremap yc :call system('nc -N localhost 8377', @0)<CR>

" Allow to copy/paste between VIM instances {
"copy the current visual selection to ~/.vbuf
vmap <leader>y :w! ~/.share/.vbuf<cr>

"copy the current line to the buffer file if no visual selection
nmap <leader>y :.w! ~/.share/.vbuf<cr>

"paste the contents of the buffer file
nmap <leader>p :r ~/.share/.vbuf<cr>
" }

" turn off search highlighting (type <leader>n to de-select everything)
nmap <silent> <leader>n :silent :nohlsearch<cr>

" http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
nmap <Leader>t= :Tabularize /=<CR>
vmap <Leader>t= :Tabularize /=<CR>
nmap <Leader>t: :Tabularize /:\zs<CR>
vmap <Leader>t: :Tabularize /:\zs<CR>

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

autocmd FileType json syntax match Comment +\/\/.\+$+

" }}}

" Vim-go {{{
let g:go_metalinter_autosave = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck', 'goimports']
let g:go_jump_to_error = 0
let g:go_fmt_command = "goimports"
" let g:go_auto_sameids = 1

" Show a list of interfaces which is implemented by the type under your cursor
autocmd FileType go nmap <Leader>s <Plug>(go-implements)

" Show type info for the word under your cursor
autocmd FileType go nmap <Leader>i <Plug>(go-info)

" Open the relevant Godoc for the word under the cursor
autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

" Open the Godoc in browser
autocmd FileType go nmap <Leader>gb <Plug>(go-doc-browser)

" Run/build/test/coverage
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage)

" By default syntax-highlighting for Functions, Methods and Structs is disabled.
" Let's enable them!
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

nmap <F8> :TagbarToggle<CR>
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" turn to next or previous errors, after open location list
nmap <leader>j :lnext<CR>
nmap <leader>k :lprevious<CR>

autocmd FileType go nmap <leader>i  <Plug>(go-install)
autocmd FileType go set tabstop=4
autocmd FileType go set softtabstop=4
autocmd FileType go set shiftwidth=4
autocmd FileType go set listchars=tab:\ \ ,trail:.,extends:#,nbsp:.
let g:go_fmt_options = { 'gofmt': '-s' }

autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)

function! HackVimGo()
  autocmd! vim-go-buffer FileChangedShell <buffer>
endfunction
autocmd FileType go call HackVimGo()

" }}}

let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabContextDefaultCompletionType = "<c-n>"

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tj :tabnext
map <leader>tk :tabprevious

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

map <leader>q :q<cr>

nnoremap fa :GoAlternate<CR>
nnoremap fc :GoCallers<CR>
nnoremap fe :GoIfErr<CR>
nnoremap fi :GoImpl<CR>
nnoremap fk :GoKeyify<CR>
nnoremap fl :GoMetaLinter<CR>
nnoremap fm :GoFmt<CR>
nnoremap fp :GoImports<CR>
nnoremap frf :GoReferrers<CR>
nnoremap frn :GoRename<CR>
nnoremap fs :GoFillStruct<CR>
nnoremap ft :GoAddTags<CR>
nnoremap fv :GoVet<CR>

" https://github.com/lambdalisue/fern.vim
nnoremap fo :Fern .<CR>
nnoremap ff :Fern . -reveal=%<CR>

map <leader>lo :lopen<CR>
map <leader>lf :lfirst<CR>
map <leader>lc :lclose<CR>

" get from REMOTE, file you are merging into your branch
nnoremap dr :diffg RE
" get from BASE, common ancestor
nnoremap db :diffg BA
" get from LOCAL, file from the current branch
nnoremap dl :diffg LO

lua require'hop'.setup()
noremap <leader>w :HopWord<CR>

lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  require'lspconfig'.gopls.setup{}

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['gopls'].setup {
    capabilities = capabilities
  }
EOF