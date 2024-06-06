set conceallevel=1

colorscheme sorbet
set termguicolors

set splitbelow
set splitright

" line number and relative line numbering
set nu rnu

set textwidth=80

set incsearch
set showmatch
set hlsearch

set wildmenu
set wildoptions=pum,fuzzy
set wildmode=list:longest,lastused

set laststatus=2

set tabstop=4
set shiftwidth=4
set expandtab

syntax on

filetype on
filetype plugin indent on

inoremap jk <Esc>

nnoremap <C-j> <C-W><C-j>
nnoremap <C-k> <C-W><C-k>
nnoremap <C-l> <C-W><C-l>
nnoremap <C-h> <C-W><C-h>

nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

nnoremap n nzzzv
nnoremap N Nzzzv

" show cursorline in insert mode
:autocmd InsertEnter,InsertLeave * set cul!
