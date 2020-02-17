colorscheme solarized

" SET
set clipboard=unnamed " use system clipboard
set cursorline " highlight current cursor line
set hlsearch " highlight all search matches
set ignorecase " ignore case in search and stuff
set relativenumber number " hybrid line numbers. show relative line numbers and current line number
set smartcase " use case if search includes uppercase characters
set spell " enable spell checker
set spelllang=en_us " default dictionary
set t_Co=16 " limit to 16 colors. fixes ale gutter color issue

let g:mapleader="\<Space>" " using space as <leader>

" KEY MAPPINGS

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" disable highlight shortcut
nnoremap <leader>h :let @/ = ""<cr>

" FILETYPES

augroup Templates
  autocmd!
  autocmd BufNewFile *.spec.js,*.test.js 0read ~/.vim/templates/spec.js.template
  autocmd BufNewFile .vimrc.local 0read ~/.vim/templates/.vimrc.local.template
augroup END
