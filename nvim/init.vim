" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
" Plug 'tpope/vim-sensible'
" Plug 'scrooloose/nerdtree'
" Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
" Plug 'scrooloose/nerdcommenter'
" List ends here. Plugins become visible to Vim after this call.

Plug 'itchyny/lightline.vim'
Plug 'ap/vim-css-color'

call plug#end()

set clipboard=unnamedplus
set number
syntax on
set tabstop=4
set mouse=a
set incsearch
set hlsearch
set autoindent
set expandtab
set encoding=utf-8

