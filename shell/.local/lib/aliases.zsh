alias '\-'='cd -'
alias '..'='cd ..'

function help() {
  bash -c "help $*"
}

function gwo() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1 \
    || { echo "Error: not in a git repo" >&2; return 1; }

  local branch
  if [[ $# -eq 0 ]]; then
    local trunk header preview_cmd
    trunk=$(git trunk)
    header="Current branch: $(git rev-parse --abbrev-ref HEAD)"
    preview_cmd="git log --graph --oneline --color ${trunk}..{} 2>/dev/null | head -20"
    local selected
    selected=$(
      {
        git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)'
        git for-each-ref --sort=-committerdate refs/remotes/ --format='%(color:red)%(refname)%(color:reset)'
      } | fzf --prompt="branch > " --height=40% --reverse --ansi +s -0 \
          --header "$header" --preview "$preview_cmd"
    ) || return 0
    branch=$(sed 's|^refs/remotes/[^/]*/||' <<< "$selected")
  else
    branch="$1"
  fi

  local repo_root repo_name repo_parent dir_slug worktree_dir ticket_id
  repo_root=$(git worktree list --porcelain | awk '/^worktree/{print $2; exit}')
  repo_name=$(basename "$repo_root")
  repo_parent=$(dirname "$repo_root")
  ticket_id=$(echo "$branch" | grep -oE '^[a-z]+-[0-9]+' || true)
  if [[ -n "$ticket_id" ]]; then
    dir_slug="$ticket_id"
  else
    dir_slug="${branch//\//-}"
  fi
  worktree_dir="${repo_parent}/${repo_name}-${dir_slug}"

  local is_new_worktree=0
  if [[ ! -d "$worktree_dir" ]]; then
    local existing_wt
    existing_wt=$(git worktree list --porcelain 2>/dev/null \
      | awk -v b="refs/heads/$branch" '/^worktree/{wt=$2} $0=="branch "b{print wt}')
    [[ -n "$existing_wt" ]] && { echo "Error: branch already open at $existing_wt" >&2; return 1; }

    echo "==> Creating worktree at $worktree_dir"
    if git show-ref --verify --quiet "refs/heads/$branch"; then
      git worktree add "$worktree_dir" "$branch"
    elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
      git worktree add --track -b "$branch" "$worktree_dir" "origin/$branch"
    else
      local current_branch
      current_branch=$(git rev-parse --abbrev-ref HEAD)
      echo "==> Creating new branch $branch from $current_branch"
      git worktree add -b "$branch" "$worktree_dir" "$current_branch"
    fi
    is_new_worktree=1
  fi

  cd "$worktree_dir" || return 1
  local window_name="${repo_name}/${branch}"
  tmux rename-window "${window_name:0:50}" 2>/dev/null || true

  if [[ $is_new_worktree -eq 1 ]]; then
    echo "✓ Created and navigated to new worktree: $branch"
  else
    echo "✓ Navigated to existing worktree: $branch"
  fi
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
