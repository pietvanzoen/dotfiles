alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"
alias vim=nvim
vm() {
  __clean_old_session_file
  if [ -e ./Session.vim ]; then
    nvim -S
  else
    nvim -c 'Obsession' .
  fi
}

__clean_old_session_file() {
  [[ ! -e ./Session.vim ]] && return;
  age='12 hours'
  if __file_last_modified ./Session.vim $age; then
    echo "==> Cleaning old Session.vim (last modified more than $age ago)"
    sleep 1
    trash ./Session.vim
  fi
}

__file_last_modified() {
  local filename
  filename=$1
  age=$2
  one_day=$(date -d "now - $age" +%s)
  file_time=$(date -r "$filename" +%s)

  # ...and then just use integer math:
  if (( file_time <= one_day )); then
    return 0
  else
    return 1
  fi
}
