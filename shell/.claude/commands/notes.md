---
name: notes
description: Update .claude-notes with current task summary and PR info
allowed-tools: Bash(claude-notes-update *)
---

Write a one-line summary of what was just done and what comes next, then run:

```
claude-notes-update "<done> → <next step>"
```

Be detailed — include file names, ticket IDs, feature names when relevant. No trailing punctuation.
If there's no clear next step, just summarize what was done.
