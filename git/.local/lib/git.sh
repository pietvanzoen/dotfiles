
alias grt=". git-root"

export GIT_PATH="$HOME/repos/" # for git get
export GIT_GET_DEFAULT_PREFIX="git@github.com:"
is_executable hub && eval "$(hub alias -s)"

gg() {
  dir="$(git get $1)"
  [[ -n "$dir" ]] && cd $dir
}
