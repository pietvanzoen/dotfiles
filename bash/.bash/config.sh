# COLORS
export TERM=xterm-256color

# AUTOJUMP
[[ -f /usr/local/etc/profile.d/autojump.sh ]] && . /usr/local/etc/profile.d/autojump.sh
[[ -f $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

# RVM
[ -e $HOME/.rvm/scripts/rvm ] && source $HOME/.rvm/scripts/rvm
[ -d $HOME/.rvm/bin ] && export PATH="$PATH:$HOME/.rvm/bin"

# GNU LS colors
[ -e $HOME/.dir_colors ] && eval "$(dircolors ~/.dir_colors)"

# BIN
export PATH=$HOME/bin:$PATH

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# SSH
[ -e $HOME/.ssh/rsa_id ] && export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

# GO BINARIES
export GO_PATH="$HOME/go"
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
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --no-ignore --hidden --files --color=never --glob "!.git/" --glob "!.DS_Store"'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --reverse'

# GNU COMMANDS
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# HOMEBREW
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"
