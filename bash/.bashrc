[ -e $HOME/.bashrc.local ] && source $HOME/.bashrc.local
source $HOME/.shell/config.sh
source $HOME/.shell/aliases.sh
source $HOME/.shell/git-completion.bash
source $HOME/.bash/aliases.sh
source $HOME/.bash/prompt.sh
source $HOME/.bash/bash-preexec.sh

set -o vi
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

preexec() {
  # RESET CURSOR TO BLOCK BEFORE EXECUTING COMMAND.
  # Fixes issue where my bash vi mode indicator (a thin cursor)
  # persists when starting vim.
  echo -ne "\e[2 q"
}
