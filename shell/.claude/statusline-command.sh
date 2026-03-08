#!/usr/bin/env bash
# Claude Code status line script
# Displays: dirname (magenta) + git branch/dirty/ahead/behind (yellow) + PR number (cyan, if any)
# PR lookup is cached in /tmp to avoid slowing down the status line.

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
dir_name=$(basename "$cwd")

git_status=""
pr_part=""

if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

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

# Session cost & environmental estimates
cost_part=""
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

if [ -n "$cost_usd" ] && [ "$cost_usd" != "null" ] && [ "$cost_usd" != "0" ]; then
  # Format cost
  cost_fmt=$(printf '$%.2f' "$cost_usd")

  # Energy estimate: ~6 Wh per 1M tokens (large model inference)
  total_tokens=$(( total_input + total_output ))
  energy_wh=$(awk "BEGIN { printf \"%.1f\", $total_tokens / 1000000.0 * 6.0 }")

  # Water estimate: ~0.5 mL per Wh (data center cooling)
  water_ml=$(awk "BEGIN { printf \"%.0f\", $energy_wh * 0.5 }")

  cost_part=" $(printf '\033[32m')${cost_fmt}$(printf '\033[0m') $(printf '\033[90m')⚡${energy_wh}Wh ∿${water_ml}mL$(printf '\033[0m')"
fi

printf "$(printf '\033[95m')%s$(printf '\033[0m')%s%s%s" "$dir_name" "$git_status" "$pr_part" "$cost_part"
