
# SHELL
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias reshell="source ~/.zshrc"
alias restow="$(dotfilesdir)/stow-all"
alias cl=clear
alias vm="vim . -S ~/.vim/sessions/\${PWD##*/}.vim"
alias j=z
alias gtop="cd $(git rev-parse --show-toplevel)"
alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"

# base command
alias ls="gls --color=auto --group-directories-first --ignore='.DS_Store'"
alias l='ls -lAh'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'

# SCREEN
alias sl="screen -ls | sed '1d;\$d' | sed '\$d' | sed 's/[[:space:]]/ /g' | sed 's/\./ /' | column -s \" \" -t | sort -k 2,2"
alias sr="screen -r"
alias ss="screen -S"

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
