# HELPERS
is_executable() {
  if hash $1 >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

source "$HOME/.env"

# COLORS
export TERM=xterm-256color

# BIN
export PATH=$HOME/bin:$PATH

# HOMEBREW PATHS
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export MANPATH="/usr/local/opt/curl/share/man:$MANPATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"

# GO BINARIES
export GOPATH="$HOME/go"
[ -d "$GOPATH/bin" ] && export PATH="$PATH:$GOPATH/bin"

# RVM
[ -e $HOME/.rvm/scripts/rvm ] && source $HOME/.rvm/scripts/rvm
[ -d $HOME/.rvm/bin ] && export PATH="$PATH:$HOME/.rvm/bin"

# AUTOJUMP
[[ -f /etc/profile.d/autojump.sh ]] && . /etc/profile.d/autojump.sh
[[ -f /usr/local/etc/profile.d/autojump.sh ]] && . /usr/local/etc/profile.d/autojump.sh
[[ -f $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

# GNU LS colors
is_executable dircolors && eval "$(dircolors $XDG_CONFIG_HOME/bash/.dir_colors)"

# SSH
[ -e $HOME/.ssh/id_rsa ] && export SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# EDITOR
if is_executable nvim; then
  export EDITOR="$(which nvim)"
elif is_executable vim; then
  export EDITOR="$(which vim)"
elif is_executable vi; then
  export EDITOR="$(which vi)"
fi


# HISTORY
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups;
export HISTIGNORE="cd:cd -:pwd:exit:date";

# FZF
# Setting rg as the default source for fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if is_executable fd; then
  export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --color=always'
fi

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --reverse --ansi'

# HOMEBREW
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"
export HOMEBREW_NO_ANALYTICS=1 # disable homebrew analytics

# RIPGREP
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/bash/.ripgreprc"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# YARN
#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# BASH COMPLETION
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi
