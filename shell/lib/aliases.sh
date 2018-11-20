# GENERAL
alias gtop="cd \$(git rev-parse --show-toplevel || echo '.')"
alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"
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

# base command
alias ls="ls --color=auto --group-directories-first --ignore='.DS_Store' -H"
alias ll='ls -lAh'
alias rm='rm -I'
alias cp='cp -vi'
alias mv='mv -vi'
alias rsync="rsync -azrv --progress"
alias tree="tree --dirsfirst"
alias t="tree -a -I 'node_modules|.git' --dirsfirst"

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

# RUBY
alias be="bundle exec"
alias bi="bundle check || bundle install"

# TERMUX
if [[ "$(pwd)" =~ "com.termux" ]]; then
  alias c=termux-clipboard-set
  alias v=termux-clipboard-get
fi

# NPM
alias show-scripts="jq .scripts package.json"

# GIT
alias grt=". git-root"

# TMUX
alias ta="tmux a"
alias tdev="tmux new-session -A -s dev"
