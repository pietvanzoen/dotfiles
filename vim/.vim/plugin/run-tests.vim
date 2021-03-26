
function! RunTests(test_command) abort
  if (a:test_command !=# '')
    let l:test_command = a:test_command
  elseif (exists('g:test_command'))
    let l:test_command = g:test_command
  else
    let l:test_command = 'yarn test'
  endif
  let l:tcmd = substitute(l:test_command, '%', expand('%'), '')

  let l:cmd = 'clear && echo "==> Running ' . l:tcmd . '" && echo && time ' . l:tcmd

  if exists(':VimuxRunCommand')
    call VimuxRunCommand(l:cmd)
  else
    " disable gitgutter while running external test command otherwise rendering gets messed up
    exec ':GitGutterDisable | CocDisable'
    exec ':wall'
    exec ':!' . l:cmd
    exec ':redraw! | GitGutterEnable | CocEnable'
  endif
endfunction
let g:VimuxOpenExtraArgs = "-c bash"

command! -nargs=? RunTests call RunTests(<q-args>)
map <leader>t :RunTests<cr>
