set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'sheerun/vim-polyglot'

Plugin 'scrooloose/syntastic'

Plugin 'Valloric/YouCompleteMe'

" Plugin 'rust-lang/rust.vim'

" Plugin 'phildawes/racer'

" Plugin 'ervandew/supertab'

call vundle#end()
filetype plugin indent on

set hidden
" let g:racer_cmd = "/Users/paul/.vim/bundle/racer/target/release/racer"

syntax on

set laststatus=2

set t_Co=256

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup


set number
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smarttab

set scrolloff=5               " keep at least 5 lines above/below
set sidescrolloff=5           " keep at least 5 lines left/right
