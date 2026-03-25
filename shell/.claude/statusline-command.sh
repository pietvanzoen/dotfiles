#!/usr/bin/env bash
# Claude Code status line script
# Displays: dirname (magenta) + git branch/dirty/ahead/behind (yellow) + PR link (cyan, OSC 8 hyperlink, if any)
# PR lookup is cached in /tmp to avoid slowing down the status line.

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Truncation helpers
# Dir: trim from the RIGHT so the beginning stays visible (max 30 chars)
dir_name=$(basename "$cwd")
if [ ${#dir_name} -gt 30 ]; then
  dir_name="${dir_name:0:29}…"
fi

# Colors
C_RESET=$(printf '\033[0m')
C_BOLD=$(printf '\033[1m')
C_DIM=$(printf '\033[90m')
C_MAGENTA=$(printf '\033[95m')
C_YELLOW=$(printf '\033[33m')
C_CYAN=$(printf '\033[36m')
C_GREEN=$(printf '\033[32m')
C_BLUE=$(printf '\033[34m')

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

  git_status=" ${C_YELLOW}${branch}${dirty}${remote}${C_RESET}"

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
        pr_url=$(GH_NO_UPDATE_NOTIFIER=1 timeout 5 gh pr view --json url -q '.url' 2>/dev/null)
        if [ -n "$pr_url" ] && [ "$pr_url" != "null" ]; then
          printf '%s' "$pr_url" > "$cache_file"
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
        if [[ "$cached_pr" == http* ]]; then
          pr_num=$(basename "$cached_pr")
          esc=$'\033'
          pr_link="${esc}]8;;${cached_pr}${esc}\\#${pr_num}${esc}]8;;${esc}\\"
          pr_part=" ${C_CYAN}${pr_link}${C_RESET}"
        else
          # Legacy cache: plain number (no hyperlink)
          pr_part=" ${C_CYAN}#${cached_pr}${C_RESET}"
        fi
      else
        # Show "no PR" for non-trunk branches
        trunk=$(git -C "$cwd" config --get init.defaultBranch 2>/dev/null || echo "main")
        if [ "$branch" != "$trunk" ]; then
          pr_part=" ${C_DIM}no PR${C_RESET}"
        fi
      fi
    fi
  fi
fi

# Notes: stage + next step from .claude-notes (local file read, no blocking)
notes_part=""
notes_file="$cwd/.claude-notes"
if [ -f "$notes_file" ]; then
  notes_stage=$(grep '^stage:' "$notes_file" 2>/dev/null | head -1 | sed 's/^stage: *//')
  notes_next=$(grep '^next:' "$notes_file" 2>/dev/null | head -1 | sed 's/^next: *//')
  if [ -n "$notes_stage" ]; then
    case "$notes_stage" in
      setup|context)          stage_color="$C_DIM"    ;;
      planning)               stage_color="$C_YELLOW" ;;
      dev)                    stage_color="$C_GREEN"  ;;
      pr|review|human-review) stage_color="$C_CYAN"   ;;
      cleanup)                stage_color="$C_BLUE"   ;;
      *)                      stage_color="$C_DIM"    ;;
    esac
    inner="${stage_color}${notes_stage}${C_RESET}"
    if [ -n "$notes_next" ]; then
      if [ ${#notes_next} -gt 35 ]; then
        notes_next="${notes_next:0:34}…"
      fi
      inner="${inner} ${C_BOLD}›${C_RESET} ${notes_next}"
    fi
    notes_part="  ${C_BOLD}•${C_RESET} ${inner} ${C_BOLD}•${C_RESET}"
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
if [ -n "$model_short" ]; then
  model_color="$C_DIM"
  [ "$model_short" = "opus" ] && model_color=$(printf '\033[31m')  # red
  model_part=" ${model_color}${model_short}${C_RESET}"
fi

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
  cost_part=" ${C_DIM}${cost_fmt} ⚡${energy_wh}Wh ∿${water_ml}mL ctx:${ctx_used}k/${ctx_size}k${C_RESET}"
fi

printf '%s%s%s%s%s%s%s%s' "$C_MAGENTA" "$dir_name" "$C_RESET" "$git_status" "$pr_part" "$notes_part" "$model_part" "$cost_part"
