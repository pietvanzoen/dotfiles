function! PackInit() abort
  packadd minpac

  call minpac#init()

  call minpac#add('airblade/vim-gitgutter') " gutter notations for git status
  call minpac#add('ctrlpvim/ctrlp.vim') " fuzzy file finder
  call minpac#add('dense-analysis/ale') " gutter linting
  call minpac#add('editorconfig/editorconfig-vim') " editorconfig.org
  call minpac#add('machakann/vim-highlightedyank') " briefly highlight yanked text
  call minpac#add('roman/golden-ratio') " perfect split resizing
  call minpac#add('sheerun/vim-polyglot') " all the language packages. but syntax only
  call minpac#add('tpope/vim-commentary') " language aware commenting command
  call minpac#add('tpope/vim-eunuch') " unix helpers
  call minpac#add('tpope/vim-fugitive') " git commands
  call minpac#add('tpope/vim-sensible') " sensible defaults

endfunction

" Ctrl-P
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
let g:ctrlp_show_hidden=1
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'


" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()
