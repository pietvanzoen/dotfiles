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
# C_BOLD=$(printf '\033[1m')  # only used by notes (disabled)
C_DIM=$(printf '\033[90m')
C_MAGENTA=$(printf '\033[95m')
C_YELLOW=$(printf '\033[33m')
C_CYAN=$(printf '\033[36m')
C_GREEN=$(printf '\033[32m')
# C_BLUE=$(printf '\033[34m')  # only used by notes (disabled)

git_status=""
pr_part=""

if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  if [ ${#branch} -gt 25 ]; then
    branch="${branch:0:24}…"
  fi

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

# Notes: disabled — claude-notes no longer used
# notes_part=""
# notes_file="$cwd/.claude-notes"
# if [ -f "$notes_file" ]; then
#   notes_stage=$(grep '^stage:' "$notes_file" 2>/dev/null | head -1 | sed 's/^stage: *//')
#   notes_next=$(grep '^next:' "$notes_file" 2>/dev/null | head -1 | sed 's/^next: *//')
#   if [ -n "$notes_stage" ]; then
#     case "$notes_stage" in
#       setup|context)          stage_color="$C_DIM"    ;;
#       planning)               stage_color="$C_YELLOW" ;;
#       dev)                    stage_color="$C_GREEN"  ;;
#       pr|review|human-review) stage_color="$C_CYAN"   ;;
#       cleanup)                stage_color="$C_BLUE"   ;;
#       *)                      stage_color="$C_DIM"    ;;
#     esac
#     inner="${stage_color}${notes_stage}${C_RESET}"
#     if [ -n "$notes_next" ]; then
#       if [ ${#notes_next} -gt 35 ]; then
#         notes_next="${notes_next:0:34}…"
#       fi
#       inner="${inner} ${C_BOLD}›${C_RESET} ${notes_next}"
#     fi
#     notes_part="  ${C_BOLD}•${C_RESET} ${inner} ${C_BOLD}•${C_RESET}"
#   fi
# fi

# Session token/context usage & plan rate limits
cost_part=""

model=$(echo "$input" | jq -r '.model // ""')
model_short=""
case "$model" in
  *opus*)   model_short="opus" ;;
  *sonnet*) model_short="sonnet" ;;
  *haiku*)  model_short="haiku" ;;
esac
if [ -n "$model_short" ]; then
  case "$model_short" in
    opus)   model_color=$(printf '\033[31m')  ; model_sym="O" ;;  # red
    sonnet) model_color="$C_YELLOW"           ; model_sym="S" ;;  # yellow
    haiku)  model_color="$C_GREEN"            ; model_sym="H" ;;  # green
    *)      model_color="$C_DIM"              ; model_sym="?" ;;
  esac

  effort=$(echo "$input" | jq -r '.session.effort_level // .effortLevel // .effort.level // .effort // ""')
  effort_part=""
  if [ -n "$effort" ] && [ "$effort" != "auto" ]; then
    case "$effort" in
      low)    effort_color="$C_GREEN"              ; effort_sym="○"  ;;  # green — cheap
      medium) effort_color="$C_YELLOW"             ; effort_sym="◐"  ;;  # yellow — moderate
      high)   effort_color=$(printf '\033[31m')    ; effort_sym="●"  ;;  # red — thinking on
      max)    effort_color=$(printf '\033[91m')    ; effort_sym="⦿"  ;;  # bright red — max thinking
      *)      effort_color="$C_DIM"                ; effort_sym="$effort" ;;
    esac
    effort_part="${C_DIM}:${C_RESET}${effort_color}${effort_sym}${C_RESET}"
  fi

  model_part=" ${model_color}${model_sym}${C_RESET}${effort_part}"
fi

format_tokens() {
  local val=${1:-0}
  if [ "$val" -ge 1000000 ]; then
    awk "BEGIN { printf \"%.1fM\", $val/1000000 }"
  elif [ "$val" -ge 1000 ]; then
    awk "BEGIN { printf \"%.0fk\", $val/1000 }"
  else
    printf '%s' "$val"
  fi
}

ctx_size_raw=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
if [ "$ctx_size_raw" -gt 0 ]; then
  # Context window usage
  ctx_used_raw=$(echo "$input" | jq -r '[.context_window.current_usage.input_tokens // 0, .context_window.current_usage.cache_creation_input_tokens // 0, .context_window.current_usage.cache_read_input_tokens // 0] | add')
  ctx_used=$(awk "BEGIN { printf \"%.0f\", $ctx_used_raw/1000 }")
  ctx_size=$(awk "BEGIN { printf \"%.0f\", $ctx_size_raw/1000 }")
  ctx_pct=$(awk "BEGIN { printf \"%.0f\", ($ctx_used_raw / $ctx_size_raw) * 100 }")
  # Auto-compact fires at ~70%; warn before that threshold
  if [ "$ctx_pct" -ge 65 ]; then
    ctx_color=$(printf '\033[91m')   # bright red — approaching auto-compact threshold
  elif [ "$ctx_pct" -ge 55 ]; then
    ctx_color=$(printf '\033[31m')   # red — getting full
  elif [ "$ctx_pct" -ge 40 ]; then
    ctx_color="$C_YELLOW"            # yellow — heads up
  else
    ctx_color="$C_DIM"               # dim — normal
  fi
  cost_part=" ${ctx_color}ctx:${ctx_used}k/${ctx_size}k${C_RESET}"
fi

# Plan usage (5h/7d rate-limit windows), in place of $ cost for subscription plans
usage_color() {
  local pct=$1
  if awk "BEGIN{exit !($pct >= 85)}"; then
    printf '\033[91m'    # bright red — near limit
  elif awk "BEGIN{exit !($pct >= 65)}"; then
    printf '\033[31m'    # red
  elif awk "BEGIN{exit !($pct >= 40)}"; then
    printf '%s' "$C_YELLOW"
  else
    printf '%s' "$C_DIM"
  fi
}

five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

usage_part=""
if [ -n "$five_hour_pct" ]; then
  fh_fmt=$(awk "BEGIN { printf \"%.0f\", $five_hour_pct }")
  fh_color=$(usage_color "$five_hour_pct")
  usage_part="${usage_part} ${fh_color}5h:${fh_fmt}%${C_RESET}"
fi
if [ -n "$seven_day_pct" ]; then
  sd_fmt=$(awk "BEGIN { printf \"%.0f\", $seven_day_pct }")
  sd_color=$(usage_color "$seven_day_pct")
  usage_part="${usage_part} ${sd_color}7d:${sd_fmt}%${C_RESET}"
fi

printf '%s%s%s%s%s%s%s%s' "$C_MAGENTA" "$dir_name" "$C_RESET" "$git_status" "$pr_part" "$model_part" "$usage_part" "$cost_part"
