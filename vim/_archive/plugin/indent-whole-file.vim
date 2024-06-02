if exists('g:loaded_indent_whole_file')
  finish
endif
let g:loaded_indent_whole_file = 1

augroup AutoIndent
  autocmd!
  autocmd BufWritePre * call AutoIndent()
augroup END

function! AutoIndent() abort
  if !exists('g:auto_indent_whole_file') | return | endif
  call IndentWholeFile()
endfunction

function! IndentWholeFile() abort
  let l:winview = winsaveview()
  silent exe 'normal gg=G'
  call winrestview(l:winview)
endfunction
command! IndentWholeFile call IndentWholeFile()
