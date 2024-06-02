augroup Templates
  autocmd!
  autocmd BufNewFile *.spec.js,*.test.js 0read ~/.config/nvim/templates/spec.js.template
  autocmd BufNewFile .vimrc.local 0read ~/.config/nvim/templates/.vimrc.local.template
  autocmd BufNewFile robots.txt 0read ~/.config/nvim/templates/robots.txt.template
augroup END
