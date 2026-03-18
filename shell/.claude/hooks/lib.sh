#!/usr/bin/env bash
# Shared helpers for Claude Code hooks

set_claude_state() {  # arg: thinking|needs_input|finished|idle
  [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ] || return
  tmux set-window-option -t "$TMUX_PANE" -u @claude-thinking 2>/dev/null || true
  tmux set-window-option -t "$TMUX_PANE" -u @claude-needs-input 2>/dev/null || true
  tmux set-window-option -t "$TMUX_PANE" -u @claude-done 2>/dev/null || true
  case "$1" in
    thinking)    tmux set-window-option -t "$TMUX_PANE" @claude-thinking 1 2>/dev/null || true ;;
    needs_input) tmux set-window-option -t "$TMUX_PANE" @claude-needs-input 1 2>/dev/null || true ;;
    finished)    tmux set-window-option -t "$TMUX_PANE" @claude-done 1 2>/dev/null || true ;;
  esac
}
