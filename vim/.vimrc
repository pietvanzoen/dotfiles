scriptencoding utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
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
set clipboard=unnamed " use system clipboard
set backspace=indent,eol,start " backspace behaves normally
set timeoutlen=500 " how long leader commands wait before executing
set laststatus=2 " always show status line
set noshowmode " hide mode in command line, shown in statusline instead
set completeopt-=preview " disable preview window
set colorcolumn=72,120

"ignores
set wildignore+=*/.git/*,*/tmp/*,*.swp,**/node_modules/**
set wildmode=longest,list
set wildmenu

" set whitespace chars
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·

" persist undo history
if !isdirectory($HOME . '/.vim/undo')
  call mkdir($HOME . '/.vim/undo')
endif
set undodir=~/.vim/undo
set undofile

let g:mapleader="\<Space>" " using space as <leader>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter' " gutter notations for git status
Plug 'christoomey/vim-tmux-navigator' " seamless navigation between tmux/vim
Plug 'ajh17/VimCompletesMe' " smarter tab completion
Plug 'ctrlpvim/ctrlp.vim' " fuzzy file finder
Plug 'editorconfig/editorconfig-vim' " editorconfig.org
Plug 'edkolev/tmuxline.vim', { 'on': ['Tmuxline', 'TmuxlineSnapshot'] } " generate tmux statusline matching vim statusline
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': ['go'] } " golang stuff
Plug 'google/vim-searchindex' " show total and index of current search
Plug 'itchyny/lightline.vim' " better statusline
Plug 'junegunn/goyo.vim', { 'on': ['Goyo'] } " Nice markdown editing
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] } " better find command
Plug 'roman/golden-ratio' " perfect split resizing
Plug 'sheerun/vim-polyglot' " all the language packages. but syntax only
Plug 'tpope/vim-commentary' " language aware commenting command
Plug 'tpope/vim-fugitive' " git commands
Plug 'tpope/vim-repeat' " more things to repeat
Plug 'tpope/vim-rhubarb', { 'on': ['Gbrowse'] } " github extention for fugitive
Plug 'tpope/vim-surround' " surround char manipulation
Plug 'tpope/vim-vinegar' " netrw helper commands
Plug 'w0rp/ale' " gutter linting
Plug 'wincent/terminus' " vim iterm ui impovements
Plug 'xolox/vim-misc' | Plug 'xolox/vim-session'
Plug 'yssl/QFEnter' " better quicklist keyboard shortcuts
call plug#end()

command! PlugSync :so ~/.vimrc | PlugClean! | PlugInstall


" CTRLP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup CtrlP
  autocmd!
  autocmd BufNewFile * silent CtrlPClearCache " clear cache when a new file is created
augroup END

let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore={'dir': 'node_modules\|\.git',
                          \ 'file': '\.swp$'}
let g:ctrlp_switch_buffer='Et'
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
  let l:project = CurrentWorkingDir()
  let l:branch = fugitive#head() !=# '' ? '(' . fugitive#head() . ')' : ''
  return l:project . l:branch
endfunction

function! LightlineMode()
  return expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ expand('%:t') ==# '[Plugins]' ? 'Plugins' :
        \ &filetype ==# 'qf' ? 'Quickfix' :
        \ &filetype ==# 'netrw' ? 'Explorer' :
        \ lightline#mode()
endfunction


" TERMINUS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:TerminusMouse = 1

" VIM-GREPPER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:ale_fixers = {
"       \ 'javascript': ['eslint', 'prettier'],
"       \ 'javascript.jsx': ['eslint'],
"       \ 'vim': ['vint'] }
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'


" VIM-SESSIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:session_directory = '~/.vim/sessions/'
let g:session_autosave = 'yes'
let g:session_autoload = 'no'

function! EnableSession()
  exec ':SaveSession ' . CurrentWorkingDir()
endfunction

function! NewSession()
  exec ':tabedit .'
  exec ':tabonly'
  call EnableSession()
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
  call ReloadLocalVimrc(0)
endfunction

function! OpenPreviousSession(bang)
  let l:session = exists('g:session_previous') ? g:session_previous : ''
  if l:session ==# ''
    echom 'No previous session to restore'
  else
    call OpenSesh(g:session_previous, a:bang)
  endif
endfunction

command! EnableSession :call EnableSession()
command! NewSession :call NewSession()
command! OpenProjectSession call OpenProjectSession()
command! -bang OpenPreviousSession call OpenPreviousSession(<q-bang>)
command! -bar -bang -nargs=? -complete=customlist,xolox#session#complete_names OpenSesh call OpenSesh(<q-args>, <q-bang>)

nnoremap π :OpenSesh<space>
nnoremap <leader>ss :EnableSession<cr>
nnoremap <leader>so :OpenSesh<space>
nnoremap <leader>sr :OpenProjectSession<cr>
nnoremap <leader>sp :OpenPreviousSession<cr>
nnoremap <leader>sn :NewSession<cr>


" QLEnter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']


" TMUXLINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tmuxline_powerline_separators = 0
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '',
    \ 'right' : '',
    \ 'right_alt' : '•',
    \ 'space' : ' '}


" GIT GUTTER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_eager = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEY MAPPING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" quick redraw
nmap <leader>re :redraw!<cr>

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
  if (a:test_command !=# '')
    let l:test_command = a:test_command
  elseif (exists('g:test_command'))
    let l:test_command = g:test_command
  else
    let l:test_command = 'yarn test'
  endif
  " disable gitgutter while running external test command otherwise rendering gets messed up
  exec ':GitGutterDisable | ALEDisable'
  exec ':wall'
  exec ':!clear && echo "Running ' . l:test_command . '" && time ' . l:test_command
  exec ':GitGutterEnable | ALEEnable'
endfunction
command! -nargs=? RunTests call RunTests(<q-args>)
map <leader>t :RunTests<cr>

" vim plug
nmap <leader>ps :PlugSync<cr>
nmap <leader>pi :PlugInstall<cr>
nmap <leader>pc :PlugClean!<cr>

" grepper search
nmap <leader>* :Grepper -tool git -open -switch -cword -noprompt<cr>
nmap <leader>gg :Grepper<cr>

" disable highlight shortcut
nmap <leader>h :let @/ = ""<cr>

" replace bad spelling with first suggestion
map <leader>z 1z=

" search for currently selected text
vnoremap // y/<C-R>"<CR>

nnoremap <leader>af :ALEFix\|ALELint\|w<cr>
nnoremap <leader>an :ALENext<cr>
nnoremap <leader>ap :ALEPrevious<cr>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx

  " Clear all autocmds in the group
  autocmd!

  " clean trailing whitespace on save
  autocmd BufWritePre *.go let b:do_not_clean_whitespace=1
  autocmd BufWritePre * CleanTrailingWhitespace

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

  autocmd BufRead,BufNewFile *.raml set filetype=yaml

  " special formatting for markdown files
  autocmd FileType markdown setlocal wrap linebreak nolist

  " go formatting
  autocmd Filetype go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

  " Set vim cwd to current file directory when in INSERT mode.
  " Enables file completion relative to current file, but maintains project
  " dir as cwd for NORMAL mode operations.
  autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
  autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)

  " prepopulate new files
  autocmd BufNewFile *.spec.js,*.test.js 0read ~/.vim/templates/spec.template.js

augroup END


" NETRW SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner = 0
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
function! ReloadLocalVimrc(warn) abort
  let l:git_path = system('git rev-parse --show-toplevel 2>/dev/null')
  let l:git_vimrc = substitute(l:git_path, '\n', '', '') . '/.vimrc.local'
  if !empty(glob(l:git_vimrc))
    sandbox exec ':source ' . l:git_vimrc
  else
    if a:warn
      call ErrorMessage('.vimrc.local not found in this repo')
    endif
  endif
endfunction
call ReloadLocalVimrc(0)
command! ReloadLocalVimrc call ReloadLocalVimrc(1)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CLEAN WHITESPACE
" cleans trailing whitespace at end of line and end of file
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CleanTrailingWhitespace() abort
  if exists('b:do_not_clean_whitespace')
    return
  endif
  let l:line = line('.')
  let l:col = col('.')
  exec '%s/\s\+$//e'
  exec '%s/\($\n\s*\)\+\%$//e'
  call cursor(l:line, l:col)
endfunction
command! CleanTrailingWhitespace call CleanTrailingWhitespace()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UTILITY FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! CurrentWorkingDir()
  return split(getcwd(), '/')[-1]
endfunction

function! CursorWord()
  let l:line = getline('.')
  return matchstr(l:line[:(col('.')-1)], '\k*$') . matchstr(l:line[(col('.')-1):], '^\k*')[1:]
endfunction

function! ErrorMessage(msg)
  echohl WarningMsg | echo a:msg | echohl None
endfunction

" colors
"set t_Co=16 " 16 colors
set background=dark
colorscheme solarized
