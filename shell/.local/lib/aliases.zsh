alias '\-'='cd -'
alias '..'='cd ..'
alias cl='clear'

function help() {
  bash -c "help $*"
}

function cc() {
  clear
  # Auto-detect claudecode.nvim IDE integration for the current workspace
  local ide_port=""
  local lock_dir="$HOME/.claude/ide"
  if [[ -d "$lock_dir" ]]; then
    local cwd="$PWD"
    for lock_file in "$lock_dir"/*.lock; do
      [[ -f "$lock_file" ]] || continue
      # Check if any workspaceFolder is a prefix of cwd
      local folders
      folders=$(node -e "
        try {
          const d = JSON.parse(require('fs').readFileSync('$lock_file','utf8'));
          (d.workspaceFolders||[]).forEach(f => console.log(f));
        } catch(e) {}
      " 2>/dev/null)
      while IFS= read -r folder; do
        if [[ "$cwd" == "$folder" || "$cwd" == "$folder/"* ]]; then
          ide_port="${lock_file:t:r}"  # filename without .lock extension
          break 2
        fi
      done <<< "$folders"
    done
  fi

  if [[ -n "$ide_port" ]]; then
    CLAUDE_CODE_SSE_PORT="$ide_port" ENABLE_IDE_INTEGRATION=true claude --resume --enable-auto-mode
  else
    claude --resume --enable-auto-mode
  fi
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
    branch="${selected#refs/remotes/*/}"
  else
    branch="$1"
  fi

  local repo_root repo_name repo_parent dir_slug worktree_dir
  repo_root=$(git worktree list --porcelain | awk '/^worktree/{print $2; exit}')
  repo_name=$(basename "$repo_root")
  repo_parent=$(dirname "$repo_root")
  dir_slug="${branch//\//-}"
  if (( ${#dir_slug} > 40 )); then
    dir_slug="${dir_slug:0:40}"
    dir_slug="${dir_slug%-*}"
  fi
  worktree_dir="${repo_parent}/${repo_name}-${dir_slug}"

  local is_new_worktree=0
  if [[ ! -d "$worktree_dir" ]]; then
    local existing_wt
    existing_wt=$(git worktree list --porcelain 2>/dev/null \
      | awk -v b="refs/heads/$branch" '/^worktree/{wt=$2} $0=="branch "b{print wt}')
    if [[ -n "$existing_wt" ]]; then
      worktree_dir="$existing_wt"
    else
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
  fi

  cd "$worktree_dir" || return 1

  if [[ $is_new_worktree -eq 1 ]]; then
    echo "✓ Created and navigated to new worktree: $branch"
  else
    echo "✓ Navigated to existing worktree: $branch"
  fi
}
