scriptencoding utf-8

function! PackInit() abort
  packadd minpac

  call minpac#init()

  call minpac#add('airblade/vim-gitgutter') " gutter notations for git status
  call minpac#add('ctrlpvim/ctrlp.vim') " fuzzy file finder
  call minpac#add('editorconfig/editorconfig-vim') " editorconfig.org
  call minpac#add('honza/vim-snippets') " snippet definitions
  call minpac#add('itchyny/lightline.vim') " better statusline
  call minpac#add('junegunn/goyo.vim', { 'type': 'opt' }) " Nice markdown editing
  call minpac#add('machakann/vim-highlightedyank') " briefly highlight yanked text
  call minpac#add('neoclide/coc.nvim', { 'branch': 'release', 'do': '!yarn install --frozen-lockfile' })
  call minpac#add('roman/golden-ratio') " perfect split resizing
  call minpac#add('sheerun/vim-polyglot') " all the language packages. but syntax only
  call minpac#add('tpope/vim-commentary') " language aware commenting command
  call minpac#add('tpope/vim-eunuch') " unix helpers
  call minpac#add('tpope/vim-fugitive') " git commands
  call minpac#add('tpope/vim-repeat') " more things to repeat
  call minpac#add('tpope/vim-rhubarb') " fugitive plugin for github
  call minpac#add('tpope/vim-sensible') " sensible defaults
  call minpac#add('tpope/vim-surround') " surround char manipulation
  call minpac#add('yegappan/grep') " use modern grep tools and output results to quickfix

endfunction

" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PACKAGE CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" COC
"
let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-deno',
      \ 'coc-eslint',
      \ 'coc-json',
      \ 'coc-snippets',
      \ 'coc-tslint-plugin',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ ]

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
endif
let g:ctrlp_show_hidden=1
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'

" LIGHTLINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {}
let g:lightline.colorscheme = 'solarized'
let g:lightline.active = {}
let g:lightline.active.left = [ [ 'mode', 'paste' ], [ 'cwd' ], [ 'readonly', 'filename', 'modified' ] ]
let g:lightline.active.right = [ ['obsession'], [ 'lineinfo' ], [ 'hostname', 'filetype'] ]
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
let g:lightline.component_function.obsession = 'LightlineObsession'
let g:lightline.component_function.coc = 'LighlineCoc'

function! LightlineMode()
  return expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ expand('%:t') ==# '[Plugins]' ? 'Plugins' :
        \ &filetype ==# 'qf' ? 'Quickfix' :
        \ &filetype ==# 'netrw' ? 'Explorer' :
        \ lightline#mode()
endfunction

function! LightlineObsession()
  return ObsessionStatus('●', 'Ⅱ')
endfunction

function! LighlineCoc()
  return coc#status()
endfunction


" FUGITIVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:fugitive_gitlab_domains = ['https://gitlab.ycdev.nl']


" GREP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Rg_Options = '--ignore-case'
