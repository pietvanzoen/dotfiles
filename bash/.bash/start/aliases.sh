# GENERAL
alias gtop="cd \$(git rev-parse --show-toplevel || echo '.')"
alias reshell="source ~/.bashrc"
alias restow="$(dotfilesdir)/stow-all"
alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"

[[ "$(which nvim > /dev/null 2>&1)" ]] && alias vim=nvim

# navigation
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."

# base command
alias ls="ls --color=auto --group-directories-first --ignore='.DS_Store'"
alias l='ls -lAh'
alias rm='rm -I'
alias cp='cp -vi'
alias mv='mv -vi'
alias rsync="rsync -azrv --progress"

# jobs
alias nh="nohup group-task"
alias nf="tail -f nohup.out"


function mktouch() {
  if [ $# -lt 1 ]; then
    echo "Missing argument";
    return 1;
  fi

  for f in "$@"; do
    mkdir -p -- "$(dirname -- "$f")"
    touch -- "$f"
  done
}

# SCREEN
alias sl="screen -ls | sed '1d;\$d' | sed '\$d' | sed 's/[[:space:]]/ /g' | sed 's/\./ /' | column -s \" \" -t | sort -k 2,2"
alias sr="screen -r"
alias ss="screen -S"
sc() {
  local name="$(basename $PWD): $*"
  screen -S "$name" $@
}

# RUBY
alias bi="bundle check || bundle install"

# TERMUX
if [[ "$(pwd)" =~ "com.termux" ]]; then
  alias c=termux-clipboard-set
  alias v=termux-clipboard-get
fi
