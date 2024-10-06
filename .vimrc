"General"
set number
set ignorecase
set hlsearch
set expandtab
set tabstop=2
set shiftwidth=2
set clipboard=unnamed,autoselect
set laststatus=2
set statusline+=%F
set cursorline
syntax on

"Cursors"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

"Keymaps"
imap <C-e> <Esc>$a
imap <C-a> <Esc>^i
imap <C-b> <Esc>ha
imap <C-f> <Esc>la
nnoremap <C-n> :NERDTreeToggle<CR>

"Custom Command"
command! Cpfile let @+ = expand("%")

"Auto Command"
autocmd QuickFixCmdPost *grep* cwindow

"Plugins"
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'junegunn/vim-plug'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'cocopon/iceberg.vim'

call plug#end()

"ColorScheme"
colorscheme iceberg
set background=dark
