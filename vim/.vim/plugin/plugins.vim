scriptencoding utf-8

function! PackInit() abort
  packadd minpac

  call minpac#init()

  call minpac#add('airblade/vim-gitgutter') " gutter notations for git status
  call minpac#add('ctrlpvim/ctrlp.vim') " fuzzy file finder
  call minpac#add('editorconfig/editorconfig-vim') " editorconfig.org
  call minpac#add('honza/vim-snippets') " snippet definitions
  call minpac#add('itchyny/lightline.vim') " better statusline
  call minpac#add('jremmen/vim-ripgrep') " use modern grep tools and output results to quickfix
  call minpac#add('junegunn/goyo.vim', { 'type': 'opt' }) " Nice markdown editing
  call minpac#add('mandre/mediummode') " break bad habits by limiting hjkl usage
  call minpac#add('lifepillar/vim-solarized8') " solarized colors
  call minpac#add('machakann/vim-highlightedyank') " briefly highlight yanked text
  call minpac#add('mattn/emmet-vim') " css/html abbreviations
  call minpac#add('neoclide/coc.nvim', { 'branch': 'release' })
  call minpac#add('nikvdp/ejs-syntax')
  call minpac#add('preservim/vimux') " vim/tmux test running
  call minpac#add('roman/golden-ratio') " perfect split resizing
  call minpac#add('sheerun/vim-polyglot') " all the language packages. but syntax only
  call minpac#add('shumphrey/fugitive-gitlab.vim') " fugitive gitlab handler
  call minpac#add('simnalamburt/vim-mundo') " undo history navigation
  call minpac#add('terryma/vim-multiple-cursors') " multiple cursors
  call minpac#add('tpope/vim-commentary') " language aware commenting command
  call minpac#add('tpope/vim-eunuch') " unix helpers
  call minpac#add('tpope/vim-fugitive') " git commands
  call minpac#add('tpope/vim-obsession') " better session management
  call minpac#add('tpope/vim-repeat') " more things to repeat
  call minpac#add('tpope/vim-rhubarb') " fugitive plugin for github
  call minpac#add('tpope/vim-sensible') " sensible defaults
  call minpac#add('tpope/vim-surround') " surround char manipulation

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
nnoremap ð :CtrlPTag<cr>


" LIGHTLINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {}
let g:lightline.colorscheme = 'solarized'
let g:lightline.active = {}
let g:lightline.active.left = [ [ 'mode', 'paste' ], [ 'cwd', 'gitbranch' ], [ 'readonly', 'filename', 'modified' ] ]
let g:lightline.active.right = [ ['obsession'], [ 'lineinfo' ], [ 'filetype', 'coc'] ]
let g:lightline.inactive = {}
let g:lightline.inactive.left = [ [], ['cwd'], [ 'filename' ] ]
let g:lightline.inactive.right = [ [], ['obsession'], [ 'filetype' ] ]
let g:lightline.component = {}
let g:lightline.component.filename = '%<%f'
" let g:lightline.component.hostname = system('echo -n $(whoami)@$(hostname -s || echo)')
let g:lightline.enable = { 'statusline': 1, 'tabline': 0 }
let g:lightline.component_function = {}
let g:lightline.component_function.cwd = 'CurrentWorkingDir'
let g:lightline.component_function.gitbranch = 'FugitiveHead'
let g:lightline.component_function.mode = 'LightlineMode'
let g:lightline.component_function.obsession = 'LightlineObsession'
let g:lightline.component_function.coc = 'LighlineCoc'

function! LightlineMode() abort
  return expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ expand('%:t') ==# '[Plugins]' ? 'Plugins' :
        \ &filetype ==# 'qf' ? 'Quickfix' :
        \ &filetype ==# 'netrw' ? 'Explorer' :
        \ lightline#mode()
endfunction

function! LightlineObsession() abort
  return ObsessionStatus('●', 'Ⅱ')
endfunction

function! LighlineCoc() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  if empty(msgs) | return '' | endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction

augroup LightLine
  autocmd!
  autocmd User BufEnter,CocStatusChange,CocDiagnosticChange call lightline#update()
augroup END


" FUGITIVE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:fugitive_gitlab_domains = ['https://gitlab.ycdev.nl']


" EASYMOTION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map  / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)

" " These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" " Without these mappings, `n` & `N` works fine. (These mappings just provide
" " different highlight method and have some other features )
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)

" MUNDO
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>u :MundoToggle<CR>

" EMMET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:user_emmet_leader_key='<C-Z>'
" let g:user_emmet_install_global = 0
" autocmd FileType html,css,scss EmmetInstall


" VIMUX
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:VimuxOrientation = "h"
let g:VimuxCloseOnExit = 1
function! UpdateVimuxHeight()
  let g:VimuxHeight = &columns / 7
endfunction
call UpdateVimuxHeight()
augroup Vimux
  autocmd!
  autocmd VimResized * call UpdateVimuxHeight()
augroup END


" GIT-GUTTER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fix git-gutter signcolumn coloring with solarized
" https://github.com/airblade/vim-gitgutter/issues/164#issuecomment-75758204
highlight clear SignColumn
call gitgutter#highlight#define_highlights()


" RIPGREP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rg_highlight=1
let g:rg_command='rg --vimgrep --hidden --glob !.git'


" GOLDEN RATIO
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup GoldenRatio
  autocmd!
  autocmd VimResized * exec ':GoldenRatioResize'
augroup END
