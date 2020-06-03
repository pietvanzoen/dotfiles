
function! RunTests(test_command) abort
  if (a:test_command !=# '')
    let l:test_command = a:test_command
  elseif (exists('g:test_command'))
    let l:test_command = g:test_command
  else
    let l:test_command = 'yarn test'
  endif
  let l:cmd = substitute(l:test_command, '%', expand('%'), '')
  " disable gitgutter while running external test command otherwise rendering gets messed up
  exec ':GitGutterDisable'
  exec ':wall'
  exec ':!clear && echo "Running ' . l:cmd . '" && time ' . l:cmd
  exec ':GitGutterEnable'
endfunction

command! -nargs=? RunTests call RunTests(<q-args>)
map <leader>t :RunTests<cr>
