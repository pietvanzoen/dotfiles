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
    local latest
    latest=$(grep -rl "\"gitBranch\":\"$branch\"" "$project_dir"/*.jsonl 2>/dev/null | xargs ls -t 2>/dev/null | head -1)
    if [[ -n "$latest" ]]; then
      session_id=$(basename "$latest" .jsonl)
    fi
  fi

  if [[ -n "$session_id" ]]; then
    claude --resume "$session_id" "$@"
  else
    claude "$@"
  fi
}
