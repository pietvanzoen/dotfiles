alias '\-'='cd -'
alias '..'='cd ..'

function help() {
  bash -c "help $*"
}

function cc() {
  local branch
  branch=$(git branch --show-current 2>/dev/null) || true

  if [[ -z "$branch" ]]; then
    claude "$@"
    return
  fi

  local project_dir="$HOME/.claude/projects/$(pwd | tr '/.' '-')"
  local session_id=""

  if [[ -d "$project_dir" ]]; then
    local files
    files=$(grep -rl "\"gitBranch\":\"$branch\"" "$project_dir"/*.jsonl 2>/dev/null)
    if [[ -n "$files" ]]; then
    fi
  fi

  if [[ -n "$session_id" ]]; then
    claude --resume "$session_id" "$@"
  else
    claude "$@"
  fi
}
