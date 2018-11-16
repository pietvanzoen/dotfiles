# a set of helper functions for bash scripts

_confirm() {
  [[ -n "$CONFIRM_ALL" ]] && return 0;

  echo -en "==> $1 [y/n] "
  read -n 1 answer
  echo
  if [ "$answer" == 'y' ]; then
    return 0
  else
    return 1
  fi
}

_info() {
  echo "==> $1"
}

_error() {
  echo "Error: $1"
}

_warn() {
  echo "Warning: $1"
}

is_executable() {
  if hash $1 >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}
