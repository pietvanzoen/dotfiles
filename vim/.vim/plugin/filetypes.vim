augroup FileTypes
  autocmd!

  autocmd BufRead,BufNewFile *.raml set filetype=yaml
  autocmd BufRead,BufNewFile .env.* set filetype=sh
  autocmd BufRead,BufNewFile Dockerfile.* set filetype=dockerfile
  autocmd BufRead,BufNewFile .dirrc set filetype=sh
  autocmd BufRead,BufNewFile .gitconfig* set filetype=gitconfig
  autocmd BufRead,BufNewFile *.js.snap set filetype=javascript
  autocmd BufRead,BufNewFile .dirrc* set filetype=sh
augroup END
