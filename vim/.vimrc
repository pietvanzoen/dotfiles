colorscheme solarized

" SET
set cursorline " highlight current cursor line
set hlsearch " highlight all search matches
set spell " enable spell checker
set spelllang=en_us " default dictionary

let g:mapleader="\<Space>" " using space as <leader>

" KEY MAPPINGS

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" disable highlight shortcut
nnoremap <leader>h :let @/ = ""<cr>

" PLUGINS

let g:ctrlp_show_hidden=1
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
