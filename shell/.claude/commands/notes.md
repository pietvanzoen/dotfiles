---
name: notes
description: Update .claude-notes with current task summary and PR info
allowed-tools: Read(.claude-notes), Write(.claude-notes), Edit(.claude-notes), Bash(git branch --show-current), Bash(gh pr view *)
background: true
---

Update `.claude-notes` in the current working directory.

1. Run `git branch --show-current` to get the current branch
2. Run `gh pr view --json number,state,url 2>/dev/null` to get PR info (may fail if no PR — that's fine)
3. Read the existing `.claude-notes` file if present, to preserve the `prompt:` line
4. Write `.claude-notes` with these lines in order:
   - Line 1: `prompt: <preserved from existing file>` — keep exactly as-is, do not modify
   - Line 2: a concise AI summary of what was just done and what comes next (format: `<done> → <next>`)
   - Line 3 (only if a PR exists): `pr: #<number> <state> <url>`
   - Omit the `prompt:` line entirely if the existing file has none

Example output:
```
prompt: add validation and write tests for the new endpoint
Implemented partlist update endpoint → add validation and tests
pr: #142 open https://github.com/cutr-dev/cutr-server/pull/142
```

Be detailed in the summary — use the full line to capture what was done and what comes next.
Include specific file names, feature names, or ticket IDs when relevant. No trailing punctuation.
If there's no clear next step, just summarize what was done.
