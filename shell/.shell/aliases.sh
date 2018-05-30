
# SHELL
alias restow="\$(dotfilesdir)/stow-all"
alias vm="vim . -S ~/.vim/sessions/\${PWD##*/}.vim"
alias vimm="vim -u ~/.vimrc.min"
alias gtop="cd \$(git rev-parse --show-toplevel || echo '.')"
alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"

# git
alias grt=". git-root"

# base command
alias ls="ls --color=auto --group-directories-first --ignore='.DS_Store'"
alias l='ls -lAh'
alias rm='rm -I'
alias cp='cp -vi'
alias mv='mv -vi'
alias mkdir="mkdir -v"

# SCREEN
alias sl="screen -ls | sed '1d;\$d' | sed '\$d' | sed 's/[[:space:]]/ /g' | sed 's/\./ /' | column -s \" \" -t | sort -k 2,2"
alias sr="screen -r"
alias ss="screen -S"
sc() {
  local name="$(basename $PWD): $*"
  screen -S "$name" $@
}

# TMUX
alias ta="tmux a"
alias tdev="tmux new-session -A -s dev"

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

# RUBY
alias bi="bundle check || bundle install"

# FREEWIFI
alias freewifi="sudo ifconfig en0 ether `openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`"

# TERMUX
if [[ "$(pwd)" =~ "com.termux" ]]; then
  alias c=termux-clipboard-set
  alias v=termux-clipboard-get
fi
