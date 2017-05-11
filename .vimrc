
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

execute pathogen#infect()
filetype plugin indent on

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
  let l:test_command = exists('g:test_command') ? g:test_command : ':!yarn test'
  " disable gitgutter while running external test command otherwise rendering gets messed up
  exec ':GitGutterDisable'
  exec ':wall'
  exec l:test_command
  exec ':GitGutterEnable'
endfunction
map ,t :call RunTests()<cr>

map <leader>h :nohlsearch<cr>

" replace bad spelling with first suggestion
map <leader>z 1z=

" search for visually hightlighted text
vnoremap <c-f> y<ESC>/<c-r>"<CR>

" search for currently selected text
vnoremap // y/<C-R>"<CR>

map <leader>r :TernRename<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx

  " Clear all autocmds in the group
  autocmd!

  " trim trailing whitespace on save
  autocmd BufWritePre * %s/\s\+$//e

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256 " 256 colors
set background=dark
colorscheme solarized
call togglebg#map("<F5>")

" highlight Search ctermbg=black ctermfg=NONE cterm=underline

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
" PLUGIN CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CTRLP
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore={'dir': 'node_modules\|git',
                          \ 'file': '\.swp$'}
let g:ctrlp_switch_buffer='Et'
let g:ctrlp_dont_split = 'NERD'

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
let g:NERDTreeShowHidden = 1
nmap <c-n><c-n> :NERDTreeToggle<cr>

" AIRLINE
set laststatus=2 " always show status line
set noshowmode " hide default mode in command line
" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif
" let g:airline_symbols.branch = ''
let g:airline_section_b = '%<%{split(getcwd(), "/")[-1]} %{airline#extensions#branch#get_head()}'
let g:airline_section_z = '%3l/%L:%2v'
let g:airline_theme = 'solarized'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_buffers = 0


" TERMINUS
let g:TerminusMouse = 1


" YOUCOMPLETEME
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_identifier_candidate_chars = 4

" INDENT GUIDE
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=none

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
map ,r :w\|!echo;echo;echo;echo;echo; node $PWD/.scratch<cr>

