
# SHELL
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias reshell="source ~/.zshrc"
alias cl=clear
alias j=z

# SCREEN
alias sl="screen -ls"
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
