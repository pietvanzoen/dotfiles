# Claude Code — reset tmux window state indicators on session exit
claude() {
  command claude "$@"
  if [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ]; then
    tmux set-window-option -t "$TMUX_PANE" -u @claude-thinking 2>/dev/null || true
    tmux set-window-option -t "$TMUX_PANE" -u @claude-needs-input 2>/dev/null || true
    tmux set-window-option -t "$TMUX_PANE" -u @claude-done 2>/dev/null || true
  fi
}

# GENERAL
alias xn="exe-notify"
alias date-iso="date -u +'%Y-%m-%dT%H:%M:%SZ'"
field() {
  awk "{ print \$${1} }"
}
alias fixmes="rg -A 1 --hidden --trim --iglob '!{node_modules,.git}' 'TODO|FIXME'"

# navigation
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."

# base commands
if command -v eza >/dev/null; then
  alias ls="eza --group-directories-first --ignore-glob='.DS_Store'"
  alias ll="ls -lah --git --group"
  alias llt="ll --tree"
else
  alias ls="ls --color=auto --group-directories-first --ignore='.DS_Store' -H"
  alias ll='ls -lAh'
fi
alias rm='rm -I'
alias cp='cp -vi'
alias mv='mv -vi'
alias rsync="rsync -azrv --progress"
alias tree="tree --dirsfirst"
alias t="tree -a -I 'node_modules|.git' --dirsfirst"

if command -v bat >/dev/null; then
  alias cat="bat"
fi

# SCREEN
alias sl="screen -ls | sed '1d;\$d' | sed '\$d' | sed 's/[[:space:]]/ /g' | sed 's/\./ /' | column -s \" \" -t | sort -k 2,2"
alias sr="screen -r"
alias ss="screen -S"
sc() {
  local name="$(basename $PWD): $*"
  screen -S "$name" $@
}

flushdnscache() {
  set -ex
  sudo dscacheutil -flushcache;
  sudo killall -HUP mDNSResponder;
}

alias airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport

# always allow "put back" behaviour
alias trash='trash -F'

alias rainicorn-speedtest="ssh rainicorn /home/piet/bin/librespeed-cli"
