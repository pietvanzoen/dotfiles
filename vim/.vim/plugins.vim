scriptencoding utf-8

function! PackInit() abort
  packadd minpac

  call minpac#init()

  " call minpac#add('nvim-treesitter/nvim-treesitter') " tree-sitter?
  call minpac#add('airblade/vim-gitgutter') " gutter notations for git status
  call minpac#add('editorconfig/editorconfig-vim') " editorconfig.org
  call minpac#add('fannheyward/telescope-coc.nvim') " telescope coc integration
  call minpac#add('glts/vim-textobj-comment') " comment textobjects
  call minpac#add('google/vim-searchindex') " indexes search results
  call minpac#add('honza/vim-snippets') " snippet definitions
  call minpac#add('itchyny/lightline.vim') " better statusline
  call minpac#add('jremmen/vim-ripgrep') " use modern grep tools and output results to quickfix
  call minpac#add('junegunn/goyo.vim', { 'type': 'opt' }) " Nice markdown editing
  call minpac#add('kana/vim-textobj-user') " custom text objects
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
  call minpac#add('nvim-telescope/telescope.nvim') " fuzzy file finder
  call minpac#add('preservim/vimux') " vim/tmux test running
  call minpac#add('roman/golden-ratio') " perfect split resizing
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
  call minpac#add('vim-scripts/argtextobj.vim') " argument text object

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
" if executable('fd')
"   let g:ctrlp_user_command = 'fd -H -E .git --type f --color=never "" %s'
"   let g:ctrlp_use_caching = 0
" elseif executable('git')
"   let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard', 'find %s -type f']
"   let g:ctrlp_use_caching = 0
" else
"   augroup CtrlP
"     autocmd!
"     autocmd BufNewFile * silent CtrlPClearCache " clear cache when a new file is created
"   augroup END
" endif
" let g:ctrlp_show_hidden=1
" let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
" nnoremap ð :CtrlPTag<cr>


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
let g:lightline.component_function.cwd = 'LightlineCWD'
let g:lightline.component_function.gitbranch = 'LightlineGitBranch'
let g:lightline.component_function.mode = 'LightlineMode'
let g:lightline.component_function.obsession = 'LightlineObsession'
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

" POLYGLOT
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:polyglot_disabled = ['vue']

" TELESCOPE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <c-p> <cmd>Telescope find_files theme=ivy<cr>
nnoremap <leader>ff <cmd>Telescope find_files theme=ivy<cr>
nnoremap <leader>fg <cmd>Telescope live_grep theme=ivy<cr>
nnoremap <leader>fh <cmd>Telescope help_tags theme=ivy<cr>
nnoremap <leader>fc <cmd>Telescope coc theme=ivy<cr>
nnoremap <leader>fb <cmd>Telescope current_buffer_fuzzy_find theme=ivy<cr>
nmap <silent> gd <cmd>Telescope coc definitions theme=ivy<cr>
nmap <silent> gi <cmd>Telescope coc implementations theme=ivy<cr>
nmap <silent> gr <cmd>Telescope coc references theme=ivy<cr>


lua << EOF
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local telescope_custom_actions = {}

function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = #picker:get_multi_selection()
  if not num_selections or num_selections <= 1 then
    actions.select_default(prompt_bufnr)
    return
  end
  actions.send_selected_to_qflist(prompt_bufnr)

  local results = vim.fn.getqflist()

  for _, result in ipairs(results) do
    local current_file = vim.fn.bufname()
    local next_file = vim.fn.bufname(result.bufnr)

    if current_file == "" then
      vim.api.nvim_command("edit" .. " " .. next_file)
    else
      vim.api.nvim_command(open_cmd .. " " .. next_file)
    end
  end

  vim.api.nvim_command("cd .")
end
function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "vsplit")
end
function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "split")
end
function telescope_custom_actions.multi_selection_open_tab(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "tabe")
end
function telescope_custom_actions.multi_selection_open(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
          ["<C-J>"] = actions.move_selection_next,
          ["<C-K>"] = actions.move_selection_previous,
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
EOF
