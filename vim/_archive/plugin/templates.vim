augroup Templates
  autocmd!
  autocmd BufNewFile *.spec.js,*.test.js 0read ~/.vim/templates/spec.js.template
  autocmd BufNewFile .vimrc.local 0read ~/.vim/templates/.vimrc.local.template
  autocmd BufNewFile robots.txt 0read ~/.vim/templates/robots.txt.template
augroup END
