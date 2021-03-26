# GENERAL
alias xn="exe-notify"
alias date-iso="date -u +'%Y-%m-%dT%H:%M:%SZ'"
field() {
  awk "{ print \$${1} }"
}
alias todo="rg --hidden --iglob '!{node_modules,.git}' 'TODO|FIXME'"

# navigation
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."

# base commands
if command -v exa >/dev/null; then
  alias ls="exa --group-directories-first --ignore-glob='.DS_Store'"
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

# jobs
alias nh="nohup group-task"
alias nf="tail -f nohup.out"

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
