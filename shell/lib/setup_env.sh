# HELPERS
is_executable() {
  if hash $1 >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

is_bash() {
  if [[ -n "$IS_BASH" ]]; then
    return 0
  else
    return 1
  fi
}

is_zsh() {
  if [[ -n "$IS_ZSH" ]]; then
    return 0
  else
    return 1
  fi
}

# LOCAL ENV
[[ -e $HOME/.env ]] && source $HOME/.env

# ALIASES
[[ -f $HOME/lib/aliases.sh ]] && source $HOME/lib/aliases.sh

# COLORS
export TERM=xterm-256color

# BIN
export PATH=$HOME/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

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
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

# SSH
[ -e $HOME/.ssh/id_rsa ] && export SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# GNU LS colors
is_executable dircolors && eval "$(dircolors $HOME/.dir_colors)"

# EDITOR
if is_executable nvim; then
  export EDITOR="$(which nvim)"
elif is_executable vim; then
  export EDITOR="$(which vim)"
elif is_executable vi; then
  export EDITOR="$(which vi)"
fi

# FZF
is_zsh && [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
is_bash && [ -f ~/.fzf.bash ] && source ~/.fzf.bash
# Setting fd as the default source for fzf
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
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
is_bash && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# GIT
export GIT_PATH="$HOME/repos/" # for git get
is_executable hub && eval "$(hub alias -s)"
is_bash && [[ -f $HOME/lib/git-completion.bash ]] && source $HOME/lib/git-completion.bash

# ITERM
is_bash && [[ -f $HOME/.iterm2_shell_integration.bash ]] && source $HOME/.iterm2_shell_integration.bash
is_zsh && [[ -f $HOME/.iterm2_shell_integration.zsh ]] && source $HOME/.iterm2_shell_integration.zsh

# SANDBOX
[[ -f $HOME/lib/sandbox.sh ]] && source $HOME/lib/sandbox.sh

# GNUPG
is_executable gpg-agent && [[ -z "$(pgrep gpg-agent)" ]] && eval $(gpg-agent --daemon)

# TRAVIS GEM
[[ -f $HOME/.travis/travis.sh ]] && source $HOME/.travis/travis.sh

# RUST
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

# HINT
[ -f "$HOME/Dropbox/hint/hint_db.yml" ] && export HINT_DB="$HOME/Dropbox/hint/hint_db.yml"
[ -d "$HOME/.hint/bin" ] && export PATH="$PATH:$HOME/.hint/bin"

# MAN COLORS
source $HOME/lib/man_colors.sh
