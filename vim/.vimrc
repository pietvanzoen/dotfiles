colorscheme solarized

" Assumes sensible is loaded: https://github.com/tpope/vim-sensible
set clipboard=unnamed " use system clipboard
set cursorline " highlight current cursor line
set expandtab " use spaces instead for tabs
set hlsearch " highlight all search matches
set ignorecase " ignore case in search and stuff
set nowrap " don't wrap lines by default
set relativenumber number " hybrid line numbers. show relative line numbers and current line number
set shiftwidth=2 " number of spaces to use for autoindent
set smartcase " use case if search includes uppercase characters
set softtabstop=2 " number of spaces to use for "soft tabs"
set spell " enable spell checker
set spelllang=en_us " default dictionary
set t_Co=16 " limit to 16 colors. fixes ale gutter color issue
set undodir=~/.vim/undo
set undofile

let g:mapleader="\<Space>" " using space as <leader>

" disable highlight shortcut
nnoremap <leader>h :let @/ = ""<cr>

