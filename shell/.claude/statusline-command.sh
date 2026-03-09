#!/usr/bin/env bash
# Claude Code status line script
# Displays: dirname (magenta) + git branch/dirty/ahead/behind (yellow) + PR number (cyan, if any)
# In worktree sessions: repo·worktree_name (magenta) + branch (yellow)
# PR lookup is cached in /tmp to avoid slowing down the status line.

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Worktree context (populated by Claude Code when session is inside a worktree)
worktree_name=$(echo "$input" | jq -r '.worktree.name // ""')
worktree_branch=$(echo "$input" | jq -r '.worktree.branch // ""')

if [ -n "$worktree_name" ]; then
  # In a worktree: show "repo·worktree_name"
  main_worktree=$(git -C "$cwd" worktree list --porcelain 2>/dev/null | grep "^worktree" | head -1 | cut -d' ' -f2)
  repo_name=$(basename "${main_worktree:-$cwd}")
  dir_name="${repo_name}·${worktree_name}"
else
  dir_name=$(basename "$cwd")
fi

git_status=""
pr_part=""

if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch="${worktree_branch:-$(git -C "$cwd" branch --show-current 2>/dev/null)}"

  # Dirty / staged indicators
  dirty=""
  git -C "$cwd" diff --quiet 2>/dev/null || dirty="*"
  git -C "$cwd" diff --cached --quiet 2>/dev/null || dirty="${dirty}+"

  # Ahead / behind remote
  remote=""
  if git -C "$cwd" rev-parse --verify "@{upstream}" > /dev/null 2>&1; then
    ahead=$(git -C "$cwd" rev-list "@{upstream}..HEAD" 2>/dev/null | wc -l | xargs)
    behind=$(git -C "$cwd" rev-list "HEAD..@{upstream}" 2>/dev/null | wc -l | xargs)
    [ "$ahead" -gt 0 ] && remote="${remote}↑"
    [ "$behind" -gt 0 ] && remote="${remote}↓"
  fi

  git_status=" $(printf '\033[33m')${branch}${dirty}${remote}$(printf '\033[0m')"

  # PR number — served from cache; refreshed in background when stale
  if [ -n "$branch" ]; then
    repo_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
    # Build a short, safe cache key from repo root + branch
    cache_key=$(printf '%s:%s' "$repo_root" "$branch" | md5)
    cache_file="/tmp/claude-statusline-pr-${cache_key}.cache"
    cache_ttl=60  # seconds

    # Check whether the cache file exists and is fresh
    cache_fresh=0
    if [ -f "$cache_file" ]; then
      file_age=$(( $(date +%s) - $(stat -f %m "$cache_file" 2>/dev/null || echo 0) ))
      [ "$file_age" -lt "$cache_ttl" ] && cache_fresh=1
    fi

    if [ "$cache_fresh" -eq 0 ]; then
      # Refresh in the background so the status line is never blocked
      (
        pr_num=$(GH_NO_UPDATE_NOTIFIER=1 timeout 5 gh pr view --json number -q '.number' 2>/dev/null)
        if [ -n "$pr_num" ] && [ "$pr_num" != "null" ]; then
          printf '%s' "$pr_num" > "$cache_file"
        else
          printf 'none' > "$cache_file"
        fi
      ) &
      disown 2>/dev/null || true
    fi

    # Read whatever is in the cache right now (may be from a previous run)
    if [ -f "$cache_file" ]; then
      cached_pr=$(cat "$cache_file" 2>/dev/null)
      if [ -n "$cached_pr" ] && [ "$cached_pr" != "none" ]; then
        pr_part=" $(printf '\033[36m')#${cached_pr}$(printf '\033[0m')"
      else
        # Show "no PR" for non-trunk branches
        trunk=$(git -C "$cwd" config --get init.defaultBranch 2>/dev/null || echo "main")
        if [ "$branch" != "$trunk" ]; then
          pr_part=" $(printf '\033[90m')no PR$(printf '\033[0m')"
        fi
      fi
    fi
  fi
fi

# Session cost & energy range estimate
cost_part=""
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

model=$(echo "$input" | jq -r '.model // ""')
model_short=""
case "$model" in
  *opus*)   model_short="opus" ;;
  *sonnet*) model_short="sonnet" ;;
  *haiku*)  model_short="haiku" ;;
esac
[ -n "$model_short" ] && model_part=" $(printf '\033[90m')${model_short}$(printf '\033[0m')"

if [ -n "$cost_usd" ] && [ "$cost_usd" != "null" ] && [ "$cost_usd" != "0" ]; then
  cost_fmt=$(printf '$%.2f' "$cost_usd")

  # Energy estimate based on current model. Wh per output token:
  #   opus: 0.003, sonnet: 0.0005, haiku: 0.0001. Input: 0.25× output.
  # Sources: TokenPowerBench (2024), Ren et al. (2025), vLLM benchmarks (2025).
  case "$model" in
    *opus*)  out_rate=0.003;   in_rate=0.00075  ;;
    *haiku*) out_rate=0.0001;  in_rate=0.000025 ;;
    *)       out_rate=0.0005;  in_rate=0.000125 ;;
  esac
  energy_wh=$(awk "BEGIN { printf \"%.0f\", ($total_output * $out_rate) + ($total_input * $in_rate) }")

  # Water: ~0.5 mL per Wh (evaporative cooling). Source: Ren, "Making AI Less Thirsty" (2023).
  water_ml=$(awk "BEGIN { printf \"%.0f\", $energy_wh * 0.5 }")

  # Context window usage
  ctx_used=$(echo "$input" | jq -r '[.context_window.current_usage.input_tokens // 0, .context_window.current_usage.cache_creation_input_tokens // 0, .context_window.current_usage.cache_read_input_tokens // 0] | add' | awk '{printf "%.0f", $1/1000}')
  ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0' | awk '{printf "%.0f", $1/1000}')
  cost_part=" $(printf '\033[90m')${cost_fmt} ⚡${energy_wh}Wh ∿${water_ml}mL ctx:${ctx_used}k/${ctx_size}k$(printf '\033[0m')"
fi

printf "$(printf '\033[95m')%s$(printf '\033[0m')%s%s%s%s" "$dir_name" "$git_status" "$pr_part" "$model_part" "$cost_part"
