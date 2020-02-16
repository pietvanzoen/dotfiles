colorscheme solarized

" SET
set cursorline " highlight current cursor line
set hlsearch " highlight all search matches
set spell " enable spell checker
set spelllang=en_us " default dictionary
set relativenumber number " hybrid line numbers. show relative line numbers and current line number

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

" Ctrl-P
if executable('fd')
  let g:ctrlp_user_command = 'fd -H -E .git --type f --color=never "" %s'
  let g:ctrlp_use_caching = 0
elseif executable('git')
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_use_caching = 0
else
  augroup CtrlP
    autocmd!
    autocmd BufNewFile * silent CtrlPClearCache " clear cache when a new file is created
  augroup END
  let g:ctrlp_show_hidden=1
  let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
endif
let g:ctrlp_show_hidden=1
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
