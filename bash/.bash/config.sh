# HELPERS
_executable() {
  if hash $1 >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# COLORS
export TERM=xterm-256color

# BIN
export PATH=$HOME/bin:$PATH

# GNU COMMANDS
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

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
_executable dircolors && eval "$(dircolors ~/.dir_colors)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# SSH
[ -e $HOME/.ssh/id_rsa ] && export SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# EDITOR
if _executable nvim; then
  export EDITOR="$(which nvim)"
elif _executable vim; then
  export EDITOR="$(which vim)"
elif _executable vi; then
  export EDITOR="$(which vi)"
fi


# HISTORY
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups;
export HISTIGNORE="cd:cd -:pwd:exit:date:* --help";

# FZF
# Setting rg as the default source for fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --color=always'

#export FZF_DEFAULT_COMMAND='fd --no-ignore --hidden --files --color=never --glob "!.git/" --glob "!.DS_Store"'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --reverse --ansi'

# HOMEBREW
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

# RIPGREP
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
