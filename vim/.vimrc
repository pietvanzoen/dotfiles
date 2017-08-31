
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set ruler " show cursor position in standard vim statusbar
set scrolloff=5 " keep 5 lines of space to top/bottom from current line
set autoindent " copy indent from current line when starting a new line
set nowrap " don't wrap lines by default
set expandtab " use spaces instead for tabs
set shiftwidth=2 " number of spaces to use for autoindent
set softtabstop=2 " number of spaces to use for "soft tabs"
set tabstop=4 " number of spaces to use for "hard tabs"
set cursorline " highlight current cursor line
set cmdheight=1 " height of the vim command line
set showtabline=2 " always show the tabline
set incsearch " immediately start searching with search command
"set complete-=i
set smarttab " see :h 'smarttab'
set autoread " auto update a file when it changes
set hlsearch " highlight all search matches
set ignorecase " ignore case in search and stuff
set smartcase " use case if search includes uppercase characters
set spell " enable spell checker
set spelllang=en_us " default dictionary
set number " show line numbers
set nocompatible " disable Vi compatibility settings
set clipboard=unnamed " use system clipboard
set backspace=indent,eol,start " backspace behaves normally
set timeoutlen=500 " how long leader commands wait before executing

"ignores
set wildignore+=*/.git/*,*/tmp/*,*.swp,**/node_modules/**
set wildmode=longest,list
set wildmenu

" set whitespace chars
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·

" persist undo history
if !isdirectory($HOME . "/.vim/undo")
  call mkdir($HOME . "/.vim/undo")
endif
set undodir=~/.vim/undo
set undofile

let mapleader="\<Space>" " using space as <leader>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
  " style
  set guifont=Inconsolata:h14
  set linespace=4
  let g:solarized_contrast="high"

  " hide scrollbars
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L

  " hide toolbar
  set guioptions-=T

endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter' " gutter notations for git status
Plug 'ajh17/VimCompletesMe' " smarter tab completion
Plug 'altercation/vim-colors-solarized' " solarized color scheme
Plug 'ctrlpvim/ctrlp.vim' " fuzzy file finder
Plug 'editorconfig/editorconfig-vim' " editorconfig.org
Plug 'edkolev/tmuxline.vim', { 'on': ['Tmuxline', 'TmuxlineSnapshot'] } " generate tmux statusline matching vim statusline
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': ['go'] } " golang stuff
Plug 'google/vim-searchindex' " show total and index of current search
Plug 'itchyny/lightline.vim' " better statusline
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'scss', 'less'] } " fancy html/css/scss generator commands
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] } " better find command
Plug 'roman/golden-ratio' " perfect split resizing
Plug 'sheerun/vim-polyglot' " all the language packages. but syntax only
Plug 'tpope/vim-commentary' " language aware commenting command
Plug 'tpope/vim-fugitive' " git commands
Plug 'tpope/vim-repeat' " more things to repeat
Plug 'tpope/vim-rhubarb' " github extention for fugitive
Plug 'tpope/vim-surround' " surround char manipulation
Plug 'tpope/vim-vinegar' " netrw helper commands
Plug 'w0rp/ale' " gutter linting
Plug 'wincent/terminus' " vim iterm ui impovements
Plug 'xolox/vim-misc' | Plug 'xolox/vim-session'
Plug 'yssl/QFEnter' " better quicklist keyboard shortcuts
call plug#end()

command! PlugSync :so ~/.vimrc | PlugClean! | PlugInstall

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTRLP
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore={'dir': 'node_modules\|\.git',
                          \ 'file': '\.swp$'}
let g:ctrlp_switch_buffer='Et'
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_user_command = 'find %s -type f'
if executable('rg')
  let g:ctrlp_user_command = 'rg %s
        \ --hidden
        \ --files
        \ --color=never
        \ --glob "!.git/"
        \ --glob "!node_modules/"
        \ --glob "!.DS_Store"'
  let g:ctrlp_use_caching = 0
endif

" LIGHTLINE
set laststatus=2 " always show status line
set noshowmode " hide default mode in command line
let g:lightline = {}
let g:lightline.colorscheme = 'solarized'
let g:lightline.active = {}
let g:lightline.active.left = [ [ 'mode', 'paste' ], [ 'cwd' ], [ 'readonly', 'filename', 'modified' ] ]
let g:lightline.active.right = [ [], [ 'lineinfo' ], [ 'filetype' ] ]
let g:lightline.inactive = {}
let g:lightline.inactive.left = [ [], [], [ 'filename' ] ]
let g:lightline.inactive.right = [ [], [], [ 'filetype' ] ]
let g:lightline.component = {}
let g:lightline.component.filename = '%<%f'
let g:lightline.enable = { 'statusline': 1, 'tabline': 0 }
let g:lightline.component_function = {}
let g:lightline.component_function.cwd = 'LightlineProject'
let g:lightline.component_function.mode = 'LightlineMode'

function! LightlineProject()
  let project = CurrentWorkingDir()
  let branch = fugitive#head() !=# '' ? '(' . fugitive#head() . ')' : ''
  return project . branch
endfunction

function! LightlineMode()
  return expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ expand('%:t') ==# '[Plugins]' ? 'Plugins' :
        \ &filetype ==# 'qf' ? 'Quickfix' :
        \ &filetype ==# 'netrw' ? 'Explorer' :
        \ lightline#mode()
endfunction

" TERMINUS
let g:TerminusMouse = 1

" INDENTLINE
let g:indentLine_enabled = 0       " disable indentation mark by default
let g:indentLine_faster = 1        " enable faster setting
let g:indentLine_color_term = 239  " set indent color

" VIM-GREPPER
let g:grepper = {}
let g:grepper.tools = ['rg', 'ag', 'ack', 'grep', 'findstr', 'pt', 'sift', 'git']
let g:grepper.rg = {
      \ 'grepprg':    'rg -H --no-heading --vimgrep --hidden --glob "!.git/"',
      \ 'grepformat': '%f:%l:%c:%m',
      \ 'escape':     '\^$.*+?()[]{}| ' }

command! Todo :Grepper
      \ -noprompt
      \ -tool git
      \ -grepprg git grep -nI '\(TODO\|FIXME\)'

" ALE
let g:ale_fixers = { 'javascript': ['eslint'] }

" VIM-SESSIONS
let g:session_directory = '~/.vim/sessions/'
let g:session_autosave = 'yes'
let g:session_autoload = 'no'

function! EnableSession()
  exec ':SaveSession ' . CurrentWorkingDir()
endfunction

function! OpenProjectSession()
  call OpenSesh(CurrentWorkingDir(), '!')
endfunction

function! OpenSesh(session, bang)
  exec ':wall'
  let l:guessed_sessions = xolox#session#complete_names(a:session, 0, 0)

  if len(l:guessed_sessions) == 0
    echom "Unknown session '" . a:session . "'"
    return
  endif

  let l:current_session = xolox#session#find_current_session()
  let l:session = l:guessed_sessions[0]

  if l:session == l:current_session
    echom "Session '" . l:session . "' already active"
    return
  endif

  let g:session_previous = l:current_session
  call xolox#session#open_cmd(l:session, a:bang, 'OpenSession')
  call LoadLocalVimrc()
endfunction

function! OpenPreviousSession(bang)
  let l:session = exists('g:session_previous') ? g:session_previous : ''
  if l:session == ''
    echom 'No previous session to restore'
  else
    call OpenSesh(g:session_previous, a:bang)
  endif
endfunction

command! EnableSession :call EnableSession()
command! OpenProjectSession call OpenProjectSession()
command! -bang OpenPreviousSession call OpenPreviousSession(<q-bang>)
command! -bar -bang -nargs=? -complete=customlist,xolox#session#complete_names OpenSesh call OpenSesh(<q-args>, <q-bang>)

nmap π :OpenSesh<space>
nmap <leader>so :OpenSesh<space>
nmap <leader>sr :OpenProjectSession<cr>
nmap <leader>sp :OpenPreviousSession<cr>

" CLOSETAGS
let g:unaryTagsStack=''

" QLEnter
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" TMUXLINE
let g:tmuxline_powerline_separators = 0
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '',
    \ 'right' : '',
    \ 'right_alt' : '•',
    \ 'space' : ' '}

" VIMCOMPLETESME
set completeopt-=preview " disable preview window

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256 " 256 colors
set background=dark
colorscheme solarized
call togglebg#map("<F5>")

" highlight Search ctermbg=black ctermfg=NONE cterm=underline


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEY MAPPING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" up and down on wrapped lines
nmap j gj
nmap k gk

" alt+k and alt+j for quick jumping
nnoremap ˚ 10k
nnoremap ∆ 10j
vnoremap ˚ 10k
vnoremap ∆ 10j

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" tab indenting for normal and visual mode
nnoremap ¬ >>_
nnoremap ˙ <<_
vnoremap ¬ >gv
vnoremap ˙ <gv

map <up> :echo "NO BAD PIET!"<cr>
map <down> :echo "NO BAD PIET!"<cr>
map <left> :echo "NO BAD PIET!"<cr>
map <right> :echo "NO BAD PIET!"<cr>

" default test runner command
function! RunTests(test_command)
  if (a:test_command != '')
    let l:test_command = a:test_command
  elseif (exists('g:test_command'))
    let l:test_command = g:test_command
  else
    let l:test_command = 'yarn test'
  endif
  " disable gitgutter while running external test command otherwise rendering gets messed up
  exec ':GitGutterDisable | ALEDisable'
  exec ':wall'
  exec ':!clear && echo "Running ' . l:test_command . '" && ' . l:test_command
  exec ':GitGutterEnable | ALEEnable'
endfunction
command! -nargs=? RunTests call RunTests(<q-args>)
map <leader>t :RunTests<cr>

" yarn shortcuts
nmap <leader>yi :!yarn install<cr>
nmap <leader>yf :!yarn install --force<cr>
nmap <leader>yt :!yarn test<cr>
nmap <leader>ya :!yarn add<space>

" go shortcuts
nmap <leader>gi :GoImports<cr>
nmap <leader>gr :!clear && go run %<cr>

" vim plug
nmap <leader>ps :PlugSync<cr>
nmap <leader>pi :PlugInstall<cr>
nmap <leader>pc :PlugClean!<cr>

" grepper search
nmap <leader>* :Grepper -tool git -open -switch -cword -noprompt<cr>
nmap <leader>gg :Grepper<cr>

" disable highlight shortcut
nmap <leader>h :let @/ = ""<cr>

" replace buffer instances of word under cursor
let s:rename_old_name = ''
let s:rename_new_name = ''
function! RenameCursorWord(old_name, new_name)
  if a:old_name !=# '' && a:new_name !=# ''
    let l:old_name = a:old_name
  else
    let l:old_name = CursorWord()
  endif

  if l:old_name ==# ''
    call ErrorMessage('RenameCursorWord: can not replace an empty string')
    return
  endif

  let l:new_name = input('Replace "' . l:old_name . '" with: ', a:new_name)
  if l:new_name != '' && l:new_name != l:old_name
    exec 'normal m`'
    exec '%s/' . l:old_name . '/' . l:new_name . '/gc'
    exec 'normal ``'
    redraw!
  endif
  let s:rename_old_name = l:old_name
  let s:rename_new_name = l:new_name
endfunction

function! RepeatRenameCursorWord()
  if s:rename_old_name ==# '' || s:rename_new_name ==# ''
    echo 'Previous rename not found'
    return
  endif
  call RenameCursorWord(s:rename_old_name, s:rename_new_name)
endfunction

map <leader>r :call RenameCursorWord('', '')<cr>

map <leader>rr :call RepeatRenameCursorWord()<cr>

" replace bad spelling with first suggestion
map <leader>z 1z=

" search for visually hightlighted text
vnoremap <c-f> y<ESC>/<c-r>"<CR>

" search for currently selected text
vnoremap // y/<C-R>"<CR>

map <leader>af :ALEFix\|ALELint\|w<cr>

" Toggle netrw
map <c-n><c-n> :Lexplore<CR>

" clear tabs and open project directory
function! ClearTabs()
  exec ':tabedit .'
  exec ':tabonly'
endfunction
command! ClearTabs :call ClearTabs()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx

  " Clear all autocmds in the group
  autocmd!

  " trim trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e

  " trim EOF whitespace
  autocmd BufWritePre * %s/\($\n\s*\)\+\%$//e

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

  autocmd BufRead,BufNewFile *.raml set filetype=yaml

  autocmd BufNewFile * silent CtrlPClearCache

  " hack so vim-javascript works with lazy load
  autocmd BufRead *.js set syntax=javascript

  autocmd FileType markdown setlocal wrap linebreak nolist

  autocmd Filetype go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

  " Set vim cwd to current file directory when in INSERT mode.
  " Enables file completion relative to current file, but maintains project
  " dir as cwd for NORMAL mode operations.
  autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
  autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)

  " prepopulate new files
  autocmd BufNewFile *.spec.js,*.test.js 0read ~/.vim/templates/spec.template.js

augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PIPE READER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PipeCommand(cmd)
  if !filewritable($HOME .'/.vim_pipe')
    echoerr 'Pipe "~/.vim_pipe" not found. Run pipe-run ~/.vim_pipe'
    return
  endif
  exec 'Dispatch! pipe-send -p ~/.vim_pipe ' . a:cmd
endfunction
command! -nargs=? PipeCmd call PipeCommand(<q-args>)

" NETRW SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner = 1
let g:netrw_liststyle = 1
let g:netrw_browse_split = 0
let g:netrw_winsize = 25
let g:netrw_list_hide= '.*\.swp$,.DS_Store,*/tmp/*,*.so,*.swp,*.zip,*.git'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'
map <leader>e :edit %%
map <leader>v :view %%


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REPO SPECIFIC VIMRC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! LoadLocalVimrc()
  let git_path = system("git rev-parse --show-toplevel 2>/dev/null")
  let git_vimrc = substitute(git_path, '\n', '', '') . "/.vimrc.local"
  if !empty(glob(git_vimrc))
    sandbox exec ":source " . git_vimrc
  endif
endfunction
call LoadLocalVimrc()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SCRATCH FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Scratch()
  exec ':edit $PWD/.scratch'
  exec ':set filetype=javascript'
endfunction
command! Scratch :call Scratch()

function! ScratchRunner()
  let l:run_command = exists('g:run_command') ? g:run_command : 'node $PWD/.scratch'
  " disable gitgutter while running run command otherwise rendering gets messed up
  exec ':GitGutterDisable'
  exec ':wall'
  exec ':!clear && ' . l:run_command
  exec ':GitGutterEnable'
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    redraw

    if new_name == '' || new_name == old_name
      return
    endif

    if filereadable(new_name)
      call ErrorMessage('File "' . new_name . '" already exists')
      return
    endif

    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
    echo "'" . old_name . "' -> '" . new_name . "'"
endfunction
command! RenameFile :call RenameFile()
map <leader>n :call RenameFile()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UTILITY FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! CurrentWorkingDir()
  return split(getcwd(), "/")[-1]
endfunction

function! CursorWord()
  let i = (a:0 ? a:1 : mode() ==# 'i' || mode() ==# 'R') && col('.') > 1
  let line = getline('.')
  return matchstr(line[:(col('.')-i-1)], '\k*$') . matchstr(line[(col('.')-i-1):], '^\k*')[1:]
endfunction

function! ErrorMessage(msg)
  echohl WarningMsg | echo a:msg | echohl None
endfunction
