# Track usage of commands in ~/.local/bin
# Logs each invocation to ~/.local/share/bin-usage.log

__bin_usage_track() {
  local cmd="${1%% *}"

  # Resolve aliases to their underlying command
  local resolved
  resolved="$(whence -p "$cmd" 2>/dev/null)" || return

  [[ "$resolved" == "$HOME/.local/bin/"* ]] || return

  local name="${resolved##*/}"
  local logfile="$HOME/.local/share/bin-usage.log"
  printf '%s\t%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$name" >> "$logfile"
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec __bin_usage_track
