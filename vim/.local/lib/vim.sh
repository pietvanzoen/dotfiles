alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"
alias clean-sessions="fd -HIp -E 'node_modules' 'Session.vim$|.sessions/.*session.vim$' -X rm -v"
alias vim=nvim
vm() {

  # Create .sessions folder if it doesn't exist
  if [[ ! -d './.sessions' ]]; then
    mkdir './.sessions'
  fi

  # Create a session file name based on the current branch
  local session_name=".sessions/$(git rev-parse --abbrev-ref HEAD)-session.vim"

  if [ -e $session_name ]; then
    # If the session file exists open it
    nvim -S $session_name
  else
    # Otherwise create it
    nvim -c "Obsession $session_name" .
  fi
}

# __clean_old_session_file() {
#   [[ ! -e ./Session.vim ]] && return;
#   age='12 hours'
#   if __file_last_modified ./Session.vim $age; then
#     echo "==> Cleaning old Session.vim (last modified more than $age ago)"
#     sleep 1
#     trash ./Session.vim
#   fi
# }

# __file_last_modified() {
#   local filename
#   filename=$1
#   age=$2
#   one_day=$(date -d "now - $age" +%s)
#   file_time=$(date -r "$filename" +%s)

#   # ...and then just use integer math:
#   if (( file_time <= one_day )); then
#     return 0
#   else
#     return 1
#   fi
# }
