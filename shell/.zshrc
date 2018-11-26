source $HOME/lib/load_plugins.zsh
source $HOME/lib/setup_env.sh
source $HOME/lib/aliases.zsh

setopt autocd # cd without cd
setopt globdots # match dotfiles in globs by default
setopt correct # suggest spelling corrections
setopt extendedglob # more globbing

# Set up the prompt
autoload -Uz promptinit
promptinit
prompt piet

# Use vim keybindings
bindkey -v
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
if [[ -z "$(bindkey | grep fzf)" ]]; then
  bindkey '^R' history-incremental-search-backward
fi

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

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTORY_IGNORE="(cd|cd -|pwd|exit)";
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Load help command
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-svn
autoload -Uz run-help-svk
alias help=run-help

# auto suggestion
my-autosuggest-accept() {
    zle autosuggest-accept
    zle redisplay
    zle redisplay
}
zle -N my-autosuggest-accept
bindkey '^ ' my-autosuggest-accept
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=my-autosuggest-accept
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
