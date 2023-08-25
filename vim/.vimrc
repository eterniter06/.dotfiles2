set nocompatible              " be iMproved, required

" Automate the process of installing vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
 
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim', { 'name': 'dracula' }
Plug 'tpope/vim-fugitive'
call plug#end()            " required

filetype plugin indent on    " required
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dracula'

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" END OF VIM YCM

set splitbelow
set splitright

set foldenable
set relativenumber
set number
set incsearch
set showmode
set showmatch
set hlsearch
set wildmenu
set wildmode=list:longest
set laststatus=2

set tabstop=4       " show existing tab with 4 spaces width
set shiftwidth=4    " when indenting with '>', use 4 spaces width
set expandtab       " On pressing tab, insert 4 spaces

syntax on

filetype plugin on
filetype indent on
filetype plugin indent on

inoremap jk <Esc>
inoremap JK <Esc>

nnoremap <C-j> <C-W><C-j>
nnoremap <C-k> <C-W><C-k>
nnoremap <C-l> <C-W><C-l>
nnoremap <C-h> <C-W><C-h>


highlight StatusLineNC cterm=bold ctermfg=white ctermbg=darkgray


if has ('autocmd') " Remain compatible with earlier versions

    " Auto reload vimrc when configuration file is modified
    augroup vimrc     " Source vim configuration upon save
        autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
        autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
    augroup END
      
    " Highlight the current line in insert mode
    :autocmd InsertEnter,InsertLeave * set cul!

    "Save code folding upon exit
    augroup remember_folds
        autocmd!
        autocmd BufWinLeave * mkview
        autocmd BufWinEnter * silent! loadview
    augroup END

endif " has autocmd
