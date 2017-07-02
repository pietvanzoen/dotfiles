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
