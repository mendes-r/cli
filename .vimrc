" Vundle------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Vundle end--------------------------------------------

syntax on

" Enumerate filetypes you want to highlight in code block in markdown.
" Please be careful because too many items in the list will make highlighting markdown slow.
let g:markdown_fenced_languages = ['sql']

colorscheme molokai
let g:molokai_original = 1

" Vim Airline
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
call plug#end()

" NERDTree
let g:airline_powerline_fonts = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeQuitOnOpen = 1
map <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" UTF-8
set encoding=utf-8
set fileencoding=utf-8

" Set number by default
set number
set listchars=tab:>-,trail:·,eol:¬

" Remap escape
inoremap jk <Esc>

" ALE
Plugin 'dense-analysis/ale'
Plugin 'iamcco/markdown-preview.nvim'
" Vundle---------------------------------------------------
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Vundle end----------------------------------------------
