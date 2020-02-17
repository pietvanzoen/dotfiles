" Navigates to the folder containing the current file. Borrowed from vim-vinegar:
" https://github.com/tpope/vim-vinegar/blob/master/plugin/vinegar.vim#L39-L64

if exists("g:loaded_navigate_up")
  finish
endif
let g:loaded_navigate_up = 1

function! NavigateUp() abort
  let l:file = expand('%:t')
  exec ':edit %:h'
  if get(b:, 'netrw_liststyle') == 2
    let pattern = '\%(^\|\s\+\)\zs'.escape(l:file, '.*[]~\').'[/*|@=]\=\%($\|\s\+\)'
  else
    let pattern = '^\%(| \)*'.escape(l:file, '.*[]~\').'[/*|@=]\=\%($\|\t\)'
  endif
  call search(pattern, 'wc')
endfunction
nnoremap - :call NavigateUp()<cr>
