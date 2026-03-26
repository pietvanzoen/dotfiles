---
name: notes
description: Update .claude-notes — run as the last action in every non-trivial response
allowed-tools: Bash(claude-notes-update *)
disable-model-invocation: true
---

Write a one-line summary of what was just done and what comes next, then run:

```
claude-notes-update [--stage <name>] "<done> → <next step>"
```

Be detailed — include file names, ticket IDs, feature names when relevant. No trailing punctuation.
If there's no clear next step, just summarize what was done.

Include `--stage` only when the workflow stage has changed since the last update. Valid stages:
- `setup` — Branch setup
- `context` — Context gathering
- `planning` — Planning
- `dev` — Development
- `pr` — PR creation
- `review` — PR review response
- `human-review` — Human review
- `cleanup` — Post-merge cleanup and learnings

If the stage hasn't changed, omit `--stage` — the current stage is preserved automatically.
