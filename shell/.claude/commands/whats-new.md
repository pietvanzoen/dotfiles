---
name: whats-new
description: Show recent Claude Code changelog highlights from the last weekly check
allowed-tools: Bash(cat *), Read
---

Read the file `~/.local/state/claude-code-whats-new.log` and print its contents.

If the file doesn't exist or is empty, say: "No changelog log found. Run `claude-code-whats-new` from a terminal first."

After printing, also read `~/.local/state/claude-code-whats-new` to show the last-seen version.
