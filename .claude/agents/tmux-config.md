---
name: tmux-config
description: Use this agent when editing .tmux.conf, writing tmux format strings,
  status-line expressions, key bindings, window-option logic, or hook scripts. Also
  covers Ghostty terminal gotchas.
---

## tmux gotchas

- `#{session_name}` inside `#()` shell commands gets expanded to the *current* session
  name before the shell runs — use `##{session_name}` to pass it literally
- Custom escape sequences for key bindings: use `set -s user-keys[N] "\e[seq"` +
  `bind-key -n UserN action` rather than relying on tmux recognising the sequence as
  a named key (e.g. `C-Tab`)
- `set-window-option @foo "0"` does NOT clear the option for `#{?#{@foo},...}`
  conditionals — `"0"` is non-empty and truthy; use `set-window-option -u @foo` to unset
- `set-window-option` without `-t` targets the **active client window**, not the window
  of the running process — always pass `-t "$TMUX_PANE"` in hook scripts to target the
  correct window
- `done` is a bash reserved word — avoid using it as a shell argument or `case` label
  without quoting
- Avoid double quotes inside `#()` in `set -g status-*` values — they terminate the
  surrounding tmux string; extract complex shell logic to a helper script instead
- Truncate a format string with marker: `#{=|N|…:variable}` — appends `…` only when
  truncated; e.g. `#{=|25|…:window_name}` in window-status-format
- Avoid Nerd Font glyphs in `window-status-current-format` — Ghostty renders them at
  wrong cell width causing tab shifting; ok in status-left/right (fixed width)

## Ghostty gotchas

- `command` config requires full binary paths (e.g. `/opt/homebrew/bin/tmux`) — shell
  PATH isn't set up when Ghostty runs it, so aliases and PATH-relative names fail
- With tmux `mouse on`: Cmd+Click is captured by tmux; use Shift+Cmd+Click to open URLs
  (Shift is Ghostty's mouse bypass modifier)
