source $HOME/.local/setup_env.sh

setopt autocd # cd without cd
setopt globdots # match dotfiles in globs by default
setopt extendedglob # more globbing

# Set up the prompt
[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor
autoload -Uz promptinit
promptinit
zstyle ':prompt:pure:prompt:success' color 13
zstyle ':prompt:pure:path' color 13
zstyle ':prompt:pure:jobs' color blue
zstyle ':prompt:pure:git:arrow' color yellow
zstyle ':prompt:pure:git:branch' color 10
zstyle ':prompt:pure:git:branch:cached' color magenta
zstyle ':prompt:pure:git:dirty' color yellow
zstyle ':prompt:pure:execution_time' color black

prompt pure

__black="%{$fg[black]%}"
__dark="%{$fg_light[black]%}"
__red="%{$fg[red]%}"
__red_bold="%{$fg_bold[red]%}"
__green="%{$fg[green]%}"
__green_bold="%{$fg_bold[green]%}"
__yellow="%{$fg[yellow]%}"
__blue="%{$fg[blue]%}"
__purple="%{$fg[purple]%}"
__cyan="%{$fg[cyan]%}"
__reset_color="%{$reset_color%}"

__right_prompt() {
  local -a rprompt
  local gitroot="$(git rev-parse --show-toplevel 2> /dev/null || echo '.')"
  if [[ -d "$gitroot/node_modules" ]]; then
    rprompt+=("⬢ $(node -v)")
  fi
  export RPROMPT="%F{10}${(j: :)rprompt}%{$reset_color%}"
}

precmd_functions+='__right_prompt'


# Use vim keybindings
bindkey -v
# Use emacs keybindings
# bindkey -e

# HISTORY KEY BINDINGS
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
setopt histignorealldups sharehistory HIST_IGNORE_SPACE
HISTSIZE=1000
SAVEHIST=1000
HISTORY_IGNORE="(cd|cd -|pwd|exit|*set-secret*|*secrets set*)"
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'


# auto suggestion
my-autosuggest-accept() {
    zle forward-word
    zle redisplay
}
zle -N my-autosuggest-accept
bindkey '^ ' my-autosuggest-accept
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=my-autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
ZSH_AUTOSUGGEST_USE_ASYNC=true
