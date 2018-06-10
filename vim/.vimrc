scriptencoding utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set scrolloff=5 " keep 5 lines of space to top/bottom from current line
set autoindent " copy indent from current line when starting a new line
filetype plugin indent on
set nowrap " don't wrap lines by default
set expandtab " use spaces instead for tabs
set shiftwidth=2 " number of spaces to use for autoindent
set softtabstop=2 " number of spaces to use for "soft tabs"
set cursorline " highlight current cursor line
set incsearch " immediately start searching with search command
set smarttab " see :h 'smarttab'
set autoread " auto update a file when it changes
set autowriteall " auto write buffer on commands
set hlsearch " highlight all search matches
set ignorecase " ignore case in search and stuff
set smartcase " use case if search includes uppercase characters
set spell " enable spell checker
set spelllang=en_us " default dictionary
set relativenumber " show relative line numbers
set clipboard=unnamed " use system clipboard
set backspace=indent,eol,start " backspace behaves normally
set timeoutlen=500 " how long leader commands wait before executing
set laststatus=2 " always show status line
set noshowmode " hide mode in command line, shown in statusline instead
set completeopt-=preview " disable preview window
set colorcolumn=72,120 " vertical lines at 71 and 120 chars
set wildignore+=*/.git/*,*/tmp/*,*.swp,**/node_modules/**
set wildmode=longest,list
set wildmenu

" persist undo history
if !isdirectory($HOME . '/.vim/undo')
  call mkdir($HOME . '/.vim/undo')
endif
set undodir=~/.vim/undo
set undofile

if has('nvim')
  set inccommand=nosplit
endif
let g:mapleader="\<Space>" " using space as <leader>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PACKAGES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set packpath^=~/.vim

" install minpac if it's not available
if !isdirectory($HOME . '/.vim/pack/minpac/opt/minpac')
  exec '!git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac'
endif

if exists('*minpac#init')
  call minpac#init()
  call minpac#add('airblade/vim-gitgutter') " gutter notations for git status
  call minpac#add('ajh17/VimCompletesMe') " smarter tab completion
  call minpac#add('christoomey/vim-tmux-navigator', { 'type': 'opt' }) " seamless navigation between tmux/vim. loaded on $TMUX env var
  call minpac#add('ctrlpvim/ctrlp.vim') " fuzzy file finder
  call minpac#add('editorconfig/editorconfig-vim') " editorconfig.org
  call minpac#add('fatih/vim-go', { 'type': 'opt', 'do': 'GoInstallBinaries' }) " golang stuff
  call minpac#add('google/vim-searchindex') " show total and index of current search
  call minpac#add('itchyny/lightline.vim') " better statusline
  call minpac#add('junegunn/goyo.vim', { 'type': 'opt' }) " Nice markdown editing
  call minpac#add('junegunn/vim-easy-align') " magical aligning
  call minpac#add('k-takata/minpac', {'type': 'opt' }) " minimal package manager
  call minpac#add('machakann/vim-highlightedyank') " briefly highlight yanked text
  call minpac#add('mhinz/vim-grepper') " better find command
  call minpac#add('plasticboy/vim-markdown', { 'type': 'opt' }) " nice markdown handling
  call minpac#add('Quramy/tsuquyomi', { 'type': 'opt' }) " typescript tooling
  call minpac#add('roman/golden-ratio') " perfect split resizing
  call minpac#add('sheerun/vim-polyglot') " all the language packages. but syntax only
  call minpac#add('tpope/vim-commentary') " language aware commenting command
  call minpac#add('tpope/vim-fugitive') " git commands
  call minpac#add('tpope/vim-repeat') " more things to repeat
  call minpac#add('tpope/vim-rhubarb') " github extention for fugitive
  call minpac#add('tpope/vim-surround') " surround char manipulation
  call minpac#add('w0rp/ale', { 'type': 'opt' }) " gutter linting
  call minpac#add('wincent/terminus') " vim iterm ui impovements
  call minpac#add('yssl/QFEnter') " better quicklist keyboard shortcuts
endif

command! PackUpdate packadd minpac | source $MYVIMRC | redraw | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

" LAZY LOAD PACKAGES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !empty($TMUX)
  packadd vim-tmux-navigator
endif

augroup Packages
  autocmd!
  autocmd FileType * if IsFile() | packadd ale | endif
  autocmd FileType markdown packadd vim-markdown
  autocmd FileType markdown packadd goyo.vim
  autocmd FileType typescript packadd tsuquyomi
  autocmd FileType go packadd vim-go
augroup END


" CTRLP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('fd')
  let g:ctrlp_user_command = 'fd -H -E .git --type f --color=never "" %s'
  let g:ctrlp_use_caching = 0
elseif executable('git')
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_use_caching = 0
else
  augroup CtrlP
    autocmd!
    autocmd BufNewFile * silent CtrlPClearCache " clear cache when a new file is created
  augroup END
  let g:ctrlp_show_hidden=1
  let g:ctrlp_switch_buffer='Et'
  let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
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
  let l:git_branch = substitute(system('git symbolic-ref --short HEAD 2>/dev/null'), '\n', '', 'g')
  let l:branch = l:git_branch !=# '' ? '(' . l:git_branch . ')' : ''
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
      \ 'grepprg':    "rg -H --no-heading --vimgrep --hidden --glob \'!.git/\' \'$*\'",
      \ 'grepformat': '%f:%l:%c:%m',
      \ 'escape':     "'" }

command! Todo :Grepper
      \ -noprompt
      \ -tool git
      \ -grepprg git grep -nI '\(TODO\|FIXME\)'


" ALE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'


" QLEnter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']


" VIM MARKDOWN & GOYO
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_folding_disabled = 1
nnoremap <leader>gy :Goyo<cr>


" TSUQUYOMI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tsuquyomi_disable_quickfix = 1


" EASY-ALIGN
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


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

" grepper search
nmap <leader>* :Grepper -tool git -open -switch -cword -noprompt<cr>
nmap <leader>gg :Grepper<cr>

" disable highlight shortcut
nnoremap <leader>h :let @/ = ""<cr>

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
augroup MyAutoCmds
  autocmd!

  " clean trailing whitespace on save
  autocmd BufWritePre *.go let b:do_not_clean_whitespace=1
  autocmd BufWritePre * CleanTrailingWhitespace

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

  " Set vim cwd to current file directory when in INSERT mode.
  " Enables file completion relative to current file, but maintains project
  " dir as cwd for NORMAL mode operations.
  autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
  autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)
augroup END

augroup FileTypes
  autocmd!
  autocmd BufRead,BufNewFile *.raml set filetype=yaml
  autocmd FileType markdown setlocal wrap linebreak nolist " special formatting for markdown files
  autocmd Filetype go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
augroup END

augroup Templates
  autocmd!
  autocmd BufNewFile *.spec.js,*.test.js 0read ~/.vim/templates/spec.template.js
augroup END


" SESSIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:session_directory = $HOME . '/.vim/sessions/'
if !isdirectory(g:session_directory)
  call mkdir(g:session_directory)
endif

function! GetSessionFilepath() abort
  let l:project = GetCurrentGitProject()
  if empty(l:project)
    let l:project = getcwd()
  endif
  let l:session_file = g:session_directory . substitute(l:project, '[./ ]', '_', 'g') . '.vim'
  return l:session_file
endfunction

function! SessionSave() abort
  execute 'mksession! ' . GetSessionFilepath()
endfunction

function! SessionRestore() abort
  let l:session = GetSessionFilepath()
  if filereadable(l:session)
    execute 'source ' . l:session
  else
    call ErrorMessage('Session for ' . getcwd() . ' not found')
  endif
endfunction

function! SessionNew() abort
  exec ':tabedit . | tabonly'
  call SessionSave()
endfunction

augroup Sessions
  autocmd!
  autocmd VimLeave * call SessionSave()
augroup END

command! SessionSave call SessionSave()
command! SessionRestore call SessionRestore()
command! SessionNew call SessionNew()

nnoremap <leader>ss :SessionSave<cr>
nnoremap <leader>sr :SessionRestore<cr>
nnoremap <leader>sn :SessionNew<cr>


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
" jump to directory containing current file
function! JumpUp() abort
  let l:current_file = expand('%:t')
  exec ':edit %:h'
  call search(escape(l:current_file, '.*[]~\'), 'wc')
endfunction
nnoremap - :call JumpUp()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REPO SPECIFIC VIMRC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ReloadLocalVimrc(warn) abort
  let l:git_path = GetCurrentGitProject()
  let l:git_vimrc = substitute(l:git_path, '\n', '', '') . '/.vimrc.local'
  if !empty(glob(l:git_vimrc))
    sandbox exec ':source ' . l:git_vimrc
  else
    if a:warn
      call ErrorMessage('.vimrc.local not found in this repo')
    endif
  endif
endfunction
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

function! GetCurrentGitProject() abort
  return substitute(system('git rev-parse --show-toplevel 2>/dev/null'), '\n$', '', '')
endfunction

function! ErrorMessage(msg)
  echohl WarningMsg | echo a:msg | echohl None
endfunction

function! IsFile() abort
  if expand('%:t') ==# 'ControlP' ||
   \ expand('%:t') ==# '[Plugins]' ||
   \ &filetype ==# 'qf' ||
   \ &filetype ==# 'netrw' ||
   \ &filetype ==# ''
    return 0
  endif
  return 1
endfunction

" colors
"set t_Co=16 " 16 colors
set background=dark
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FINAL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call ReloadLocalVimrc(0)
