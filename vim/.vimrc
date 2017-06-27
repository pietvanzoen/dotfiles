
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
set wildignore+=**/node_modules/**
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
Plug 'editorconfig/editorconfig-vim'
Plug 'google/vim-searchindex'
Plug 'itchyny/lightline.vim'
Plug 'kien/ctrlp.vim'
Plug 'mhinz/vim-grepper'
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
Plug 'roman/golden-ratio'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle', 'for': 'netrw' }
Plug 'ternjs/tern_for_vim', { 'do': 'npm install', 'for': ['javascript'] }
Plug 'tpope/vim-fugitive'
Plug 'xolox/vim-misc' | Plug 'xolox/vim-session'
Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py --tern-completer' }
Plug 'w0rp/ale'
Plug 'wincent/terminus'
Plug 'Yggdroot/indentLine'
call plug#end()

command! PlugSync PlugClean! | PlugInstall

augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTRLP
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore={'dir': 'node_modules\|\.git',
                          \ 'file': '\.swp$'}
let g:ctrlp_switch_buffer='Et'
let g:ctrlp_dont_split = 'NERD'
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0

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

" NERDTREE
function! ToggleNERDTree()
  if NERDTreeIsOpen() == 0
    exec ':NERDTreeCWD'
  else
    exec ':NERDTreeToggle'
  endif
endfunction
nmap <c-n><c-n> :call ToggleNERDTree()<cr>
nmap <leader>g :NERDTreeFind<cr>
let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

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
  return expand('%:t') ==# '__Tagbar__' ? 'Tagbar':
        \ expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ expand('%:t') ==# '[Plugins]' ? 'Plugins' :
        \ &filetype ==# 'unite' ? 'Unite' :
        \ &filetype ==# 'vimfiler' ? 'VimFiler' :
        \ &filetype ==# 'vimshell' ? 'VimShell' :
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
runtime autoload/grepper.vim
let g:grepper.jump = 1
let g:grepper.stop = 500
noremap <leader>gr :GrepperRg<Space>

" ALE
let g:ale_fixers = { 'javascript': ['eslint'] }

" VIM-SESSIONS
let g:session_directory = '~/.vim/sessions/'
let g:session_autosave = 'yes'
let g:session_autoload = 'no'

function! EnableSession()
  exec ':SaveSession ' . CurrentWorkingDir()
endfunction
command! EnableSession :call EnableSession()

function! OpenProjectSession()
  exec ':OpenSession ' . CurrentWorkingDir()
endfunction
command! OpenProjectSession :call OpenProjectSession()

nmap <leader>so :OpenSession<space>
nmap <leader>sp :OpenProjectSession<cr>

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

" disable highlight shortcut
nmap <leader>h :nohlsearch<cr>

" replace bad spelling with first suggestion
map <leader>z 1z=

" search for visually hightlighted text
vnoremap <c-f> y<ESC>/<c-r>"<CR>

" search for currently selected text
vnoremap // y/<C-R>"<CR>

map <leader>f :ALEFix\|ALELint\|w<cr>

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

  " hack so vim-javascript works with lazy load
  autocmd BufRead *.js set syntax=javascript

augroup END


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

function! NERDTreeIsOpen()
  if exists('t:NERDTreeBufName')
      let l:nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
  else
      let l:nerdtree_open = 0
  endif
  return l:nerdtree_open
endfunction
