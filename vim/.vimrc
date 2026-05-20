" vim-plug: auto-install on first launch
let s:plug = expand('~/.vim/autoload/plug.vim')
if !filereadable(s:plug) && executable('curl')
  silent execute '!curl -fLo ' . s:plug . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins, skip if no vim-plug
if filereadable(s:plug)
  call plug#begin('~/.vim/plugged')

  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'

  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'

  Plug 'itchyny/lightline.vim'

  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'

  call plug#end()
endif


syntax on
filetype plugin indent on
set encoding=utf-8
set hidden
set history=10000
set backspace=indent,eol,start

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Display
set number
set ruler
set showcmd
set laststatus=2
set noshowmode                " lightline renders the mode indicator
set signcolumn=yes            " stable gutter (gitgutter + lsp diagnostics)
set scrolloff=5               " keep at least 5 lines above/below
set sidescrolloff=5           " keep at least 5 columns left/right
set wildmenu
set wildmode=longest:full,full
set updatetime=100            " snappier gitgutter updates

" Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smarttab

" Persistent undo, no swap files
set undofile
set undodir=~/.vim/undo//
if !isdirectory($HOME . '/.vim/undo')
  call mkdir($HOME . '/.vim/undo', 'p')
endif
set noswapfile

" Plugin configuration

" lightline
let g:lightline = { 'colorscheme': 'wombat' }

" asyncomplete
let g:asyncomplete_auto_popup = 1

" vim-lsp
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> K  <plug>(lsp-hover)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
endfunction

augroup lsp_install
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" fzf.vim
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
