
[ -z "$ZSH" ] && echo "\$ZSH must be defined" && exit 1;

# OH-MY-ZSH
ZSH_THEME="piet"
plugins=(brew git node nvm npm z httpie zsh-syntax-highlighting)
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

# BIN
export PATH=$HOME/bin:$PATH

# GNU LS colors
eval `gdircolors ~/.zsh/dircolors.ansi-dark`

# RVM
source $HOME/.rvm/scripts/rvm

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# BitBar state
export INTERNET_IS_DOWN=''

# FZF
ZSH_BIN=$(which zsh)
FZF_INSTALL_BIN=/usr/local/opt/fzf/install

if [[ ! -f ~/.fzf.zsh ]]; then
  if [[ ! -f $FZF_INSTALL_BIN ]]; then
    echo "fzf not installed. Run brew install fzf"
  else
    echo "installing fzf"
    $FZF_INSTALL_BIN
  fi
fi

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
