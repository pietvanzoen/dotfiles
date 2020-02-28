# test if a command is available in current shell
is_executable() {
  if hash $1 >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# test if current shell is bash
is_bash() {
  if [[ -n "$IS_BASH" ]]; then
    return 0
  else
    return 1
  fi
}

# test if current shell is zsh
is_zsh() {
  if [[ -n "$IS_ZSH" ]]; then
    return 0
  else
    return 1
  fi
}

# add a directory to PATH if it exists
add_path() {
  local dir="$1"
  if [ -d "$dir" ]; then
    export PATH="$dir:$PATH"
  fi
}

# add a directory to MANPATH if it exists
add_manpath() {
  local dir="$1"
  if [ -d "$dir" ]; then
    export MANPATH="$MANPATH:$dir"
  fi
}

# source a file if it exists
safe_source() {
  local file="$1"
  if [ -e "$file" ]; then
    source $file
  fi
}
