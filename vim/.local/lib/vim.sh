alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"
alias clean-sessions="rm -rfv .sessions"
alias vim=nvim
vm() {

  local sessions_dir="./.sessions"

  # Create .sessions folder if it doesn't exist
  if [[ ! -d "$sessions_dir" ]]; then
    mkdir "$sessions_dir"
  fi

  tmux rename-window "$(basename $(pwd))"

  local session_dir="${sessions_dir}/$(git rev-parse --abbrev-ref HEAD)"
  if [[ ! -d "${session_dir}" ]]; then
    mkdir "${session_dir}"
  fi

  local session_name="${session_dir}/Session.vim"

  if [ -e "${session_name}" ]; then
    # If the session file exists open it
    SESSION_DIR="${session_dir}" nvim -S "${session_name}"
  else
    # Otherwise create it
    SESSION_DIR="${session_dir}" nvim -c "Obsession ${session_name}" .
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
