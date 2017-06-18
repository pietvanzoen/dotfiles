
[ -z "$DOTFILES" ] && echo "\$DOTFILES must be defined" && exit 1;
[ -z "$ZSH" ] && echo "\$ZSH must be defined" && exit 1;

# OH-MY-ZSH
ZSH_THEME="piet"
plugins=(brew git node nvm npm z httpie)
source $ZSH/oh-my-zsh.sh

# ZSH
COMPLETION_WAITING_DOTS="true"
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups;
export HISTIGNORE="cd:cd -:pwd:exit:date:* --help";

# EDITOR
export EDITOR="$(which vim)"

# SSH
export SSH_KEY_PATH="~/.ssh/rsa_id"

# HUB
[ -e "$(which hub)" ] && eval "$(hub alias -s)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# ZSH SYNTAX HIGHLIGHTING
source $DOTFILES/helpers/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# RVM
source $HOME/.rvm/scripts/rvm

# BIN
export PATH=$PATH:$DOTFILES/_bin

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
