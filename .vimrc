
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

" set whitespace chars
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·

set number
highlight LineNr ctermfg=grey

set nocompatible              " be iMproved, required

execute pathogen#infect()
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEY MAPPING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" alt+k and alt+j for quick jumping
nnoremap ˚ 10k
nnoremap ∆ 10j

" tab indenting for normal and visual mode
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" default test runner command
map ,t :w\|!yarn test<cr>

nnoremap <cr> :noh<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
      return "\<tab>"
    else
      return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
" inoremap <s-tab> <c-n>

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2 " always show status line
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CTRLP
let g:ctrlp_show_hidden=1
let g:ctrlp_custom_ignore={'dir': 'node_modules\|git'}
let g:ctrlp_switch_buffer='Et'

" SYNTASTIC
let g:syntastic_mode_map = { 'mode': 'active',
                            \ 'active_filetypes': ['javascript'],
                            \ 'passive_filetypes': [] }

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REPO SPECIFIC VIMRC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let git_path = system("git rev-parse --show-toplevel 2>/dev/null")
let git_vimrc = substitute(git_path, '\n', '', '') . "/.vimrc.local"
if !empty(glob(git_vimrc))
  sandbox exec ":source " . git_vimrc
endif

