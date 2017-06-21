
# SHELL
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias reshell="source ~/.zshrc"
alias cl=clear
alias j=z
alias gtop="cd $(git rev-parse --show-toplevel)"
alias ed=edit-dir-vim
alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"

# ls
alias ls="gls --color=auto --group-directories-first --ignore='.DS_Store'"
alias l='ls -lAh'

# SCREEN
alias sl="screen -ls | sed '1d;\$d' | sed '\$d' | sed 's/[[:space:]]/ /g' | column -s \" .\" -t | sort -k 2,2"
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
