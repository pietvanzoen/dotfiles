
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set ruler
set scrolloff=5
set autoindent
set nowrap
set expandtab
set shiftwidth=2
set softtabstop=2
set cursorline
set cmdheight=1
set showtabline=2
set incsearch " instant search
set complete-=i
set smarttab
set autoread
set hlsearch
set wildmode=longest,list
set wildmenu
set ignorecase
set smartcase
set spell spelllang=en_us

" set whitespace chars
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·

set number
set nocompatible

" yank copies to os clipboard
set clipboard=unnamed

" backspace behaves normally
set backspace=indent,eol,start

" persist undo history
if !isdirectory($HOME . "/.vim/undo")
  call mkdir($HOME . "/.vim/undo")
endif
set undodir=~/.vim/undo
set undofile

let mapleader="\<Space>" " using space as <leader>

"ignores
set wildignore+=*/.git/*,*/tmp/*,*.swp,**/node_modules/**

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
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'google/vim-searchindex'
Plug 'itchyny/lightline.vim'
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'scss', 'less'] }
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
Plug 'roman/golden-ratio'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install', 'for': ['javascript'] }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py --tern-completer' }
Plug 'w0rp/ale'
Plug 'wincent/terminus'
Plug 'xolox/vim-misc' | Plug 'xolox/vim-session'
Plug 'Yggdroot/indentLine'
call plug#end()

command! PlugSync PlugClean! | PlugInstall

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

" SYNTASTIC
let g:syntastic_mode_map = { 'mode': 'active',
                            \ 'active_filetypes': ['javascript'],
                            \ 'passive_filetypes': [] }

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

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

" YOUCOMPLETEME
set completeopt-=preview " disable preview window
let g:ycm_add_preview_to_completeopt = 0
"let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_identifier_candidate_chars = 4

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
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

map <up> :echo "NO BAD PIET!"<cr>
map <down> :echo "NO BAD PIET!"<cr>
map <left> :echo "NO BAD PIET!"<cr>
map <right> :echo "NO BAD PIET!"<cr>

" default test runner command
function! RunTests()
  let l:test_command = exists('g:test_command') ? g:test_command : 'yarn test'
  " disable gitgutter while running external test command otherwise rendering gets messed up
  exec ':GitGutterDisable'
  exec ':wall'
  exec ':!clear && ' . l:test_command
  exec ':GitGutterEnable'
endfunction
map <leader>t :call RunTests()<cr>

" yarn shortcuts
nmap <leader>yi :!yarn install<cr>
nmap <leader>yf :!yarn install --force<cr>
nmap <leader>yt :!yarn test<cr>
nmap <leader>ya :!yarn add<space>

" vim plug
nmap <leader>ps :PlugSync<cr>
nmap <leader>pi :PlugInstall<cr>
nmap <leader>pc :PlugClean!<cr>

" grepper search
nmap <leader>* :Grepper -tool git -open -switch -cword -noprompt<cr>
nmap <leader>gg :Grepper<cr>

" disable highlight shortcut
nmap <leader>h :nohlsearch<cr>

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

augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
let git_path = system("git rev-parse --show-toplevel 2>/dev/null")
let git_vimrc = substitute(git_path, '\n', '', '') . "/.vimrc.local"
if !empty(glob(git_vimrc))
  sandbox exec ":source " . git_vimrc
endif


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
map <leader>r :call ScratchRunner()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
command! RenameFile :call RenameFile()
map <leader>n :call RenameFile()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UTILITY FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! CurrentWorkingDir()
  return split(getcwd(), "/")[-1]
endfunction
