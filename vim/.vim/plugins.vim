scriptencoding utf-8

function! PackInit() abort
  packadd minpac

  call minpac#init()

  " call minpac#add('kbarrette/mediummode') " prevent too many manual motions
  call minpac#add('airblade/vim-gitgutter') " gutter notations for git status
  call minpac#add('AndrewRadev/tagalong.vim') " update matching html tags
  call minpac#add('bkad/CamelCaseMotion') " camel case junction text object
  call minpac#add('deathlyfrantic/vim-textobj-blanklines') " blanklines textobject
  call minpac#add('editorconfig/editorconfig-vim') " editorconfig.org
  call minpac#add('evanleck/vim-svelte') " svelte syntax
  call minpac#add('fannheyward/telescope-coc.nvim') " telescope coc integration
  call minpac#add('github/copilot.vim') " github copilot
  call minpac#add('glts/vim-textobj-comment') " comment textobjects
  call minpac#add('godlygeek/tabular') " text alignment
  call minpac#add('google/vim-searchindex') " indexes search results
  call minpac#add('honza/vim-snippets') " snippet definitions
  call minpac#add('itchyny/lightline.vim') " better statusline
  call minpac#add('junegunn/goyo.vim', { 'type': 'opt' }) " Nice markdown editing
  call minpac#add('kana/vim-textobj-user') " custom text objects
  call minpac#add('kkharji/sqlite.lua') " lua db
  call minpac#add('kyazdani42/nvim-web-devicons') " nvim dev icons
  call minpac#add('lifepillar/vim-solarized8') " solarized colors
  call minpac#add('machakann/vim-highlightedyank') " briefly highlight yanked text
  call minpac#add('mattn/emmet-vim') " css/html abbreviations
  call minpac#add('mg979/vim-visual-multi') " multiple cursors
  call minpac#add('michaeljsmith/vim-indent-object') " indent text object
  call minpac#add('neoclide/coc.nvim', {'do': '!yarn install --frozen-lockfile'})
  call minpac#add('nikvdp/ejs-syntax')
  call minpac#add('nvim-lua/plenary.nvim') " dependency of nvim-telescope/telescope.nvim
  call minpac#add('nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }) " fzf extension for telescope
  call minpac#add('nvim-telescope/telescope-smart-history.nvim') " Telescope history
  call minpac#add('nvim-telescope/telescope.nvim') " fuzzy file finder
  call minpac#add('nvim-treesitter/nvim-treesitter') " tree-sitter?
  call minpac#add('phaazon/hop.nvim') " quick movements
  call minpac#add('posva/vim-vue') " vue stuff
  call minpac#add('preservim/vimux') " vim/tmux test running
  call minpac#add('prisma/vim-prisma') " prisma support
  call minpac#add('roman/golden-ratio') " perfect split resizing
  call minpac#add('saihoooooooo/vim-textobj-space') " space characters text object
  call minpac#add('sheerun/vim-polyglot') " all the language packages. but syntax only
  call minpac#add('shumphrey/fugitive-gitlab.vim') " fugitive gitlab handler
  call minpac#add('simnalamburt/vim-mundo') " undo history navigation
  call minpac#add('tpope/vim-abolish') " text replacement helpers
  call minpac#add('tpope/vim-commentary') " language aware commenting command
  call minpac#add('tpope/vim-eunuch') " unix helpers
  call minpac#add('tpope/vim-fugitive') " git commands
  call minpac#add('tpope/vim-obsession') " better session management
  call minpac#add('tpope/vim-repeat') " more things to repeat
  call minpac#add('tpope/vim-rhubarb') " fugitive plugin for github
  call minpac#add('tpope/vim-sensible') " sensible defaults
  call minpac#add('tpope/vim-surround') " surround char manipulation
  call minpac#add('vimtaku/vim-textobj-keyvalue') " key value text objects
  call minpac#add('wellle/targets.vim') " additional text objects
  call minpac#add('whatyouhide/vim-textobj-xmlattr') " xml attribute text object

endfunction

" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate source $HOME/.vim/plugins.vim | call PackInit() | call minpac#update()
command! PackClean  source $HOME/.vim/plugins.vim | call PackInit() | call minpac#clean()
command! PackStatus source $HOME/.vim/plugins.vim | call PackInit() | call minpac#status()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PACKAGE CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" For 1 character to search before showing hints
noremap <leader>f <Cmd>call stargate#OKvim(1)<CR>
" For 2 consecutive characters to search
noremap <leader>F <Cmd>call stargate#OKvim(2)<CR>

" Instead of 1 or 2 you can use any higher number, but it isn't much practical
" and it is easier to use `/` or `?` for that
" COC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-eslint',
      \ 'coc-json',
      \ 'coc-prettier',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-tslint-plugin',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ ]


" CAMELCASEMOTION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:camelcasemotion_key = '<leader>'


" LIGHTLINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {}
let g:lightline.colorscheme = 'solarized'
let g:lightline.active = {}
let g:lightline.active.left = [ [ 'mode', 'paste' ], [ 'cwd', 'gitbranch' ], [ 'readonly', 'filename', 'modified' ] ]
let g:lightline.active.right = [ [], [ 'lineinfo' ], [ 'filetype', 'coc'] ]
let g:lightline.inactive = {}
let g:lightline.inactive.left = [ [], ['cwd'], [ 'filename' ] ]
let g:lightline.inactive.right = [ [], [], [ 'filetype' ] ]
let g:lightline.component = {}
let g:lightline.component.filename = '%<%f'
" let g:lightline.component.hostname = system('echo -n $(whoami)@$(hostname -s || echo)')
let g:lightline.enable = { 'statusline': 1, 'tabline': 0 }
let g:lightline.component_function = {}
let g:lightline.component_function.cwd = 'LightlineCWD'
let g:lightline.component_function.gitbranch = 'LightlineGitBranch'
let g:lightline.component_function.mode = 'LightlineMode'
" let g:lightline.component_function.copilot = 'LightlineCopilot'
let g:lightline.component_function.coc = 'LighlineCoc'

function! LightlineGitBranch() abort
  return "\ue725 " .FugitiveHead()
endfunction

function! LightlineCWD() abort
  return "\uf74a " .CurrentWorkingDir()
endfunction

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

function! LightlineCopilot()
  let l:status = execute(':Copilot status')
  if l:status =~# 'Enabled'
    return "\ufba7 \uf00c"
  elseif l:status =~# 'Disabled'
    return "\ufba7 \uf04c"
  else
    return "\ufba7 \uf071"
  endif
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


" MUNDO
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>u :MundoToggle<CR>

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


" GOLDEN RATIO
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup GoldenRatio
  autocmd!
  autocmd VimResized * exec ':GoldenRatioResize'
augroup END

" POLYGLOT
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:polyglot_disabled = ['vue']

" COPILOT
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight CopilotSuggestion guifg=#555555 ctermfg=8

imap <silent><script><expr> <M-\> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
let g:copilot_filetypes = {
      \ '*': v:true,
      \ 'markdown': v:false,
      \ }

augroup Copilot
  autocmd!
  autocmd BufRead,BufNewFile .env* let b:copilot_enabled = v:false
augroup END


" HOP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap s <cmd>HopChar1<cr>


" TELESCOPE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <c-p> <cmd>Telescope find_files theme=ivy<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fm <cmd>Telescope marks<cr>
nnoremap <leader>fr <cmd>Telescope resume<cr>
nnoremap <leader>fz <cmd>Telescope spell_suggest<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>ff <cmd>Telescope grep_string<cr>
nnoremap <leader>fc <cmd>Telescope coc<cr>
nnoremap <leader>fb <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>fd <cmd>Telescope coc workspace_diagnostics<cr>
nnoremap <expr> <leader>fG ':Telescope live_grep default_text=' . expand('<cword>') .'<cr>'
nnoremap <silent> gd <cmd>Telescope coc definitions<cr>
nnoremap <silent> gi <cmd>Telescope coc implementations<cr>
nnoremap <silent> gr <cmd>Telescope coc references<cr>

lua << EOF
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

require("telescope").setup {
  defaults = {
    history = {
      path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
      limit = 100,
    },
    mappings = {
      i = {
        ["<C-J>"] = actions.move_selection_next,
        ["<C-K>"] = actions.move_selection_previous,
        ["<C-N>"] = actions.cycle_history_next,
        ["<C-P>"] = actions.cycle_history_prev,
      },
      n = {
          ["<C-J>"] = actions.move_selection_next,
          ["<C-K>"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "-H", "--type", "f", "--strip-cwd-prefix"  }
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
    },
  }
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('coc')
require('telescope').load_extension('smart_history')
require'hop'.setup {
  multi_windows = false,
}
EOF
