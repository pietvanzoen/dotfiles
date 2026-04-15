---
name: purge-sessions
description: Delete stale Claude Code sessions for the current project and branch, keeping the active session
model: haiku
allowed-tools: Bash(claude-sessions-purge*)
---

Run `claude-sessions-purge` to delete stale sessions for the current project on the current git branch.
Pass `--dry-run` first to preview, then run without it to delete.
Pass `--all-branches` to purge sessions on all branches, not just the current one.
