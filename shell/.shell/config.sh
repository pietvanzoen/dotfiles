[ -e $HOME/.shellrc.local ] && source $HOME/.shellrc.local

# AUTOJUMP
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# RVM
[ -e $HOME/.rvm/scripts/rvm ] && source $HOME/.rvm/scripts/rvm
[ -d $HOME/.rvm/bin ] && export PATH="$PATH:$HOME/.rvm/bin"

# GNU LS colors
[ -e $HOME/.shell/dircolors.ansi-dark ] && eval "$(dircolors ~/.shell/dircolors.ansi-dark)"

# BIN
export PATH=$HOME/bin:$PATH

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# HUB
[ -e "$(which hub)" ] && eval "$(hub alias -s)"

# SSH
[ -e $HOME/.ssh/rsa_id ] && export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

# GO BINARIES
[ -d "$GOPATH/bin" ] && export PATH="$PATH:$GOPATH/bin"

# EDITOR
export EDITOR="$(which vim)"

# HISTORY
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups;
export HISTIGNORE="cd:cd -:pwd:exit:date:* --help";

# FZF
# Setting rg as the default source for fzf
export FZF_DEFAULT_COMMAND='rg --no-ignore --hidden --files --color=never --glob "!.git/" --glob "!.DS_Store"'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='--height 40% --reverse'

# GNU COMMANDS
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# YARN
[ -d $HOME/.yarn/bin ] && export PATH="$HOME/.yarn/bin:$PATH"
