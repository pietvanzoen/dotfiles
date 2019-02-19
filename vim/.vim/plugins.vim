call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/SyntaxComplete' " omni completion based on syntax highlighting
Plug 'mxw/vim-jsx' " jsz highlighting
Plug 'othree/yajs.vim' " moar js syntax
Plug 'othree/javascript-libraries-syntax.vim' " js lib highlighting
Plug 'othree/es.next.syntax.vim' " js next highlighting
Plug 'airblade/vim-gitgutter' " gutter notations for git status
Plug 'ajh17/VimCompletesMe' " smarter tab completion
Plug 'christoomey/vim-tmux-navigator', { 'on': [] } " seamless navigation between tmux/vim. loaded on $TMUX env var
Plug 'ctrlpvim/ctrlp.vim' " fuzzy file finder
Plug 'easymotion/vim-easymotion' " speedy motions. <leader><leader>s for quick search
Plug 'editorconfig/editorconfig-vim' " editorconfig.org
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': ['go'] } " golang stuff
Plug 'google/vim-searchindex' " show total and index of current search
Plug 'itchyny/lightline.vim' " better statusline
Plug 'junegunn/goyo.vim', { 'on': ['Goyo'] } " Nice markdown editing
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)'] } " magical aligning
Plug 'kristijanhusak/vim-js-file-import', { 'do': ':!npm install' } " auto importing of modules
Plug 'machakann/vim-highlightedyank' " briefly highlight yanked text
Plug 'mattn/emmet-vim', { 'for': ['html', 'css'] } " css/html abbreviations
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] } " better find command
Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] } " nice markdown handling
Plug 'Quramy/tsuquyomi' " , { 'for': ['typescript'] }  typescript tooling
Plug 'roman/golden-ratio' " perfect split resizing
Plug 'RRethy/vim-illuminate' " current word subtle highlight
Plug 'sheerun/vim-polyglot' " all the language packages. but syntax only
Plug 'tpope/vim-commentary' " language aware commenting command
Plug 'tpope/vim-eunuch' " unix helpers
Plug 'tpope/vim-fugitive' " git commands
Plug 'tpope/vim-repeat' " more things to repeat
Plug 'tpope/vim-rhubarb' " github extention for fugitive
Plug 'tpope/vim-surround' " surround char manipulation
Plug 'w0rp/ale', { 'on': [] } " gutter linting
Plug 'wincent/terminus' " vim iterm ui impovements
Plug 'yssl/QFEnter', { 'for': 'qf' } " better quicklist keyboard shortcuts
call plug#end()
