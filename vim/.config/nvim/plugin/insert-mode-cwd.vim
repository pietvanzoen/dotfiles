" Set vim cwd to current file directory when in INSERT mode.
" Enables file completion relative to current file, but maintains project
" dir as cwd for NORMAL mode operations.

if exists('g:loaded_insert_mode_cwd')
  finish
endif
let g:loaded_insert_mode_cwd = 1

augroup InsertModeCwd
  autocmd!
  autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
  autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)
augroup END
