
# For /vim/bin/note
export NOTES_PATH="$HOME/Notes"

nn() {
  set -e
  local title="$*"
  if [[ -z $title ]]; then
    echo "Title required"
    return 1
  fi
  vim +2 "$(note $title)"
}

is_executable nvim && alias vim=nvim

alias vm="vim . -S ~/.vim/sessions/\${PWD##*/}.vim"
alias vimm="vim -u ~/.vimrc.min"
alias vims="vim . +SessionRestore"
