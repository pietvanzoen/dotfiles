[ -e $HOME/.bashrc.local ] && source $HOME/.bashrc.local
source $HOME/.shell/config.sh
source $HOME/.shell/aliases.sh
[[ -e $HOME/.shell/usabilla.sh ]] && source $HOME/.shell/usabilla.sh
source $HOME/.bash/git-completion.bash
source $HOME/.bash/aliases.sh
source $HOME/.bash/prompt.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
