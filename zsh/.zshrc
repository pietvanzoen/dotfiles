[ -e $HOME/.zshrc.local ] && source $HOME/.zshrc.local

# OH-MY-ZSH
ZSH_THEME="piet"
plugins=(zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh # must be loaded before aliases so custom aliases take precedence

source $HOME/.shell/config.sh
source $HOME/.shell/aliases.sh
source $HOME/.zsh/aliases.zsh

[ -z "$ZSH" ] && echo "\$ZSH must be defined" && exit 1;

# ZSH
COMPLETION_WAITING_DOTS="true"

# Use vi mode for command line editing
bindkey -v

# Restore usual command line keybindings
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^r' history-incremental-search-backward

# Use slim cursor when in insert mode. Block cursor when in normal mode.
function zle-keymap-select zle-line-init {
  # change cursor shape in iTerm2
  case $KEYMAP in
    vicmd)      print -n -- "\e[2 q";;  # block cursor
    viins|main) print -n -- "\e[5 q";;  # line cursor
  esac

  zle reset-prompt
  zle -R
}

function zle-line-finish {
  print -n -- "\e[2 q"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# faster mode switching
export KEYTIMEOUT=1

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
