
if exists('g:loaded_clean_white_space')
  finish
endif
let g:loaded_clean_white_space = 1

augroup CleanWhiteSpace
  autocmd!
  autocmd BufWritePre * CleanTrailingWhitespace
augroup END

function! CleanTrailingWhitespace() abort
  if exists('b:do_not_clean_whitespace')
    return
  endif
  let l:winview = winsaveview()
  exec '%s/\s\+$//e'
  exec '%s/\($\n\s*\)\+\%$//e'
  call winrestview(l:winview)
endfunction
command! CleanTrailingWhitespace call CleanTrailingWhitespace()
