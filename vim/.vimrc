scriptencoding utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set shell=bash " vim is slow with zsh
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
set relativenumber number " hybrid line numbers. show relative line numbers and current line number
set clipboard=unnamed " use system clipboard
set backspace=indent,eol,start " backspace behaves normally
set timeoutlen=500 " how long leader commands wait before executing
set laststatus=2 " always show status line
set noshowmode " hide mode in command line, shown in statusline instead
set showtabline=2 " always show the tabline
set completeopt-=preview " disable preview window
set colorcolumn=72,120 " vertical lines at 71 and 120 chars
set wildignore+=*/tmp/*,*.swp
set wildmode=longest,list
set wildmenu
set updatetime=500

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
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.vim/plugins.vim

" MANUAL LAZY LOAD
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !empty($TMUX)
  exec plug#load('vim-tmux-navigator')
endif

function! LoadAle()
  if IsModernVim() && IsFile()
    exec plug#load('ale')
  endif
endfunction

augroup Plugs
  autocmd!
  autocmd FileType * call LoadAle()
augroup END

" PLUG COMMAND
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! PlugSync :so ~/.vimrc | PlugClean! | PlugInstall


" CTRLP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_switch_buffer='Et'
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
  let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
endif
nnoremap π :CtrlPTag<cr>
nnoremap <c-p> :CtrlP<cr>

" LIGHTLINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {}
let g:lightline.colorscheme = 'solarized'
let g:lightline.active = {}
let g:lightline.active.left = [ [ 'mode', 'paste' ], [ 'cwd' ], [ 'readonly', 'filename', 'modified' ] ]
let g:lightline.active.right = [ [], [ 'lineinfo' ], [ 'hostname', 'filetype' ] ]
let g:lightline.inactive = {}
let g:lightline.inactive.left = [ [], [], [ 'filename' ] ]
let g:lightline.inactive.right = [ [], [], [ 'filetype' ] ]
let g:lightline.component = {}
let g:lightline.component.filename = '%<%f'
let g:lightline.component.hostname = system('echo -n $(whoami)@$(hostname -s || echo)')
let g:lightline.enable = { 'statusline': 1, 'tabline': 0 }
let g:lightline.component_function = {}
let g:lightline.component_function.cwd = 'CurrentWorkingDir'
let g:lightline.component_function.mode = 'LightlineMode'

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
let g:grepper.tools = ['rg', 'ag', 'ack', 'git', 'grep', 'findstr', 'pt', 'sift']
let g:grepper.rg = {
      \ 'grepprg':    "rg -H --no-heading --vimgrep --hidden --glob \'!.git/\' --glob \'!yarn.lock\' \'$*\'",
      \ 'grepformat': '%f:%l:%c:%m',
      \ 'escape':     "'" }

command! Todo :Grepper
      \ -noprompt
      \ -tool git
      \ -grepprg git grep -nI '\(TODO\|FIXME\)'


" ALE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_fixers = {
  \ 'typescript': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'yaml': ['prettier'],
  \ 'json': ['prettier'],
  \ 'html': ['prettier'],
  \ 'python': ['yapf'],
  \ 'ruby': ['rufo'],
  \ 'css': ['prettier'],
  \ 'scss': ['prettier'],
  \ 'sh': ['shfmt'],
  \ 'bash': ['shfmt']
  \ }
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_fix_on_save = 0


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
nnoremap <leader>ti :TsuImport<cr>

" TAGSBAR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
  \ }



" EASY-ALIGN
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" EASY MOTION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EasyMotion_smartcase = 1


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
nnoremap ]a :ALENext<cr>
nnoremap [a :ALEPrevious<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ABBREVIATIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" mistakes
inoreabbrev flase false

" simple snips
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

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
  autocmd FileType make setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd BufRead,BufNewFile .env.* set filetype=sh
  autocmd BufRead,BufNewFile Dockerfile.* set filetype=dockerfile
  autocmd BufRead,BufNewFile .dirrc set filetype=sh
  autocmd BufRead,BufNewFile .gitconfig* set filetype=gitconfig
augroup END

augroup Templates
  autocmd!
  autocmd BufNewFile *.spec.js,*.test.js 0read ~/.vim/templates/spec.js.template
  autocmd BufNewFile .vimrc.local 0read ~/.vim/templates/.vimrc.local.template
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

function! SessionSaveOnExit() abort
  if &filetype ==# 'gitcommit'
    return 0
  endif
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
  autocmd VimLeave * call SessionSaveOnExit()
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



function! CleanSwp() abort
  exec '!find . -regex ".*\.sw[p|o]$" | xargs rm -v'
endfunction
command! CleanSwp call CleanSwp()


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

function! IsModernVim()
  return !empty(matchstr(v:version, '^8'))
endfunction

" colors
"set t_Co=16 " 16 colors
set background=dark
colorscheme solarized

function! EnableWriteAndRun() abort
  nmap <cr> :wa \|!%:p<cr>
endfunction!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FINAL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call ReloadLocalVimrc(0)
