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
      vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
      viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
  esac

  zle reset-prompt
  zle -R
}

function zle-line-finish {
  print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# faster mode switching
export KEYTIMEOUT=1

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

# Setting rg as the default source for fzf
export FZF_DEFAULT_COMMAND='rg --no-ignore --hidden --files --color=never --glob "!.git/" --glob "!.DS_Store"'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='--height 40% --reverse'
