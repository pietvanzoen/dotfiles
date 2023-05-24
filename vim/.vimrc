colorscheme solarized8
set background=dark
set termguicolors


" Assumes sensible is loaded: https://github.com/tpope/vim-sensible
set clipboard=unnamed " use system clipboard
set colorcolumn=72,120 " vertical lines at 71 and 120 chars
set cursorline " highlight current cursor line
set expandtab " use spaces instead for tabs
set hlsearch " highlight all search matches
set ignorecase " ignore case in search and stuff
set modeline
set mouse=nvc
set noshowmode " hide mode in command line, shown in statusline instead
set showtabline=2 " always show tabline
set nowrap " don't wrap lines by default
set relativenumber number " hybrid line numbers. show relative line numbers and current line number
set scrolloff=5 " keep 5 lines of space to top/bottom from current line
set shell=bash " vim is slow with zsh
set shiftwidth=2 " number of spaces to use for autoindent
set smartcase " use case if search includes uppercase characters
set softtabstop=2 " number of spaces to use for "soft tabs"
set spell " enable spell checker
set spelllang=en_us " default dictionary
" set t_Co=16 " limit to 16 colors. fixes ale gutter color issue
set tags=.git/tags
set undodir=~/.vim/undo
set undofile
set diffopt+=vertical
if has("nvim")
  set inccommand=nosplit
endif

" MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:mapleader="\<Space>" " using space as <leader>

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" disable highlight shortcut
nnoremap <leader>h :let @/ = ""<cr>
"
" replace bad spelling with first suggestion
map <leader>z 1z=

" search for currently selected text
vnoremap // y/<C-R>"<CR>

let &t_ut=''

" enable gutter for netrw
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

" type %% in command mode to get current directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>

source $HOME/.vim/plugins.vim
