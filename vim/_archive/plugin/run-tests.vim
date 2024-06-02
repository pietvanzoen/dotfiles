
function! RunTests(test_command) abort
  if (a:test_command !=# '')
    let l:test_command = a:test_command
  elseif (exists('b:test_command'))
    let l:test_command = b:test_command
  elseif (exists('g:test_command'))
    let l:test_command = g:test_command
  else
    let l:test_command = 'yarn test'
  endif
  let l:tcmd = substitute(l:test_command, '%', expand('%'), '')

  " add space before so command does not polute history
  let l:cmd = ' clear && (' . l:tcmd . ')'

  exec ':wall'
  if exists(':VimuxRunCommand')
    call VimuxSendKeys("C-c")
    call VimuxRunCommand(l:cmd)
  else
    " disable gitgutter while running external test command otherwise rendering gets messed up
    exec ':GitGutterDisable | CocDisable'
    exec ':!' . l:cmd
    exec ':redraw! | GitGutterEnable | CocEnable'
  endif
endfunction

function RunFile() abort
  let l:file = expand('%')

  let l:program = ''

  if (l:file =~# '.*\.js$')
    let l:program = 'node'
  elseif (l:file =~# '.*\.ts$')
    let l:program = 'ts-node -O "{\"resolveJsonModule\": true }"'
  elseif (l:file =~# '.*\.py$')
    let l:program = 'python'
  elseif (l:file =~# '.*\.go$')
    let l:program = 'go run'
  elseif (l:file =~# '.*\.rb$')
    let l:program = 'ruby'
  elseif (l:file =~# '.*\.php$')
    let l:program = 'php'
  elseif (l:file =~# '.*\.java$')
    let l:program = 'java'
  elseif (l:file =~# '.*\.sh$')
    let l:program = 'bash'
  elseif (l:file =~# '.*\.pl$')
    let l:program = 'perl'
  elseif (l:file =~# '.*\.rs$')
    let l:program = 'rustc'
  elseif (l:file =~# '.*\.c$')
    let l:program = 'gcc'
  elseif (l:file =~# '.*\.cpp$')
    let l:program = 'g++'
  elseif (l:file =~# '.*\.lua$')
    let l:program = 'lua'
  elseif (l:file =~# '.*\.scala$')
    let l:program = 'scala'
  elseif (l:file =~# '.*\.clj$')
    let l:program = 'clojure'
  elseif (l:file =~# '.*\.exs$')
    let l:program = 'elixir'
  elseif (l:file =~# '.*\.hs$')
    let l:program = 'runhaskell'
  elseif (l:file =~# '.*\.erl$')
    let l:program = 'erl'
  elseif (l:file =~# '.*\.ml$')
    let l:program = 'ocaml'
  elseif (l:file =~# '.*\.swift$')
    let l:program = 'swift'
  endif

  if (l:program ==# '')
    echo 'No program found for file type'
    return
  endif

  let l:cmd = ' clear && echo && time (' . l:program . ' ' . l:file . ') && echo'

  exec ':wall'
  if exists(':VimuxRunCommand')
    call VimuxRunCommand(l:cmd)
  else
    " disable gitgutter while running external test command otherwise rendering gets messed up
    exec ':GitGutterDisable | CocDisable'
    exec ':!' . l:cmd
    exec ':redraw! | GitGutterEnable | CocEnable'
  endif
endfunction

function! OpenTestFile() abort
  let l:file = expand('%')
  let l:dir = substitute(expand('%:p:h'), getcwd() . '/', '', '')
  let l:filename = expand('%:t:r')
  let l:filename = substitute(l:filename, '\.test$', '', '')

  let l:target_file = ''

  if (l:file =~# '.*\.test\.js$')
    let l:target_file = l:dir . '/' . l:filename . '.js'
  elseif (l:file =~# '.*\.test\.ts$')
    let l:target_file = l:dir . '/' . l:filename . '.ts'
  elseif (l:file =~# '.*\.js$')
    let l:target_file = l:dir . '/' . l:filename . '.test.js'
  elseif (l:file =~# '.*\.ts$')
    let l:target_file = l:dir . '/' . l:filename . '.test.ts'
  endif

  if (l:target_file ==# '')
    echo 'No test file found for file type'
    return
  endif

  exec ':vsp ' . l:target_file
endfunction

command! -nargs=? RunTests call RunTests(<q-args>)
command! -nargs=? RunFile call RunFile()
command! -nargs=? OpenTestFile call OpenTestFile()
map <leader>t :RunTests<cr>
map <leader>rr :RunFile<cr>
map <leader>ot :OpenTestFile<cr>
