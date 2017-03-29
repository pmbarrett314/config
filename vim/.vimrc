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

let os = system("source $PERSONAL_CONFIG_DIR/os-info/os_info.sh && get_os")

if os=~"linux"
	python3 from powerline.vim import setup as powerline_setup
	python3 powerline_setup()
	python3 del powerline_setup
" elseif os=~"macos"
" 	python from powerline.vim import setup as powerline_setup
"	python powerline_setup()
"	python del powerline_setup
endif


set number
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smarttab

set scrolloff=5               " keep at least 5 lines above/below
set sidescrolloff=5           " keep at least 5 lines left/right
