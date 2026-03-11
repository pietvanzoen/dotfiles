---
name: notes
description: Update .claude-notes with current task summary and PR info
allowed-tools: Write(.claude-notes), Edit(.claude-notes), Bash(git branch --show-current), Bash(gh pr view *)
background: true
---

Update `.claude-notes` in the current working directory.

1. Run `git branch --show-current` to get the current branch
2. Run `gh pr view --json number,state,url 2>/dev/null` to get PR info (may fail if no PR — that's fine)
3. Write `.claude-notes` with:
   - Line 1: a concise present-tense summary of what is currently being worked on in this session
   - Line 2 (only if a PR exists): `pr: #<number> <state> <url>`

Example output:
```
Implementing partlist update endpoint and fixing controller method
pr: #142 open https://github.com/cutr-dev/cutr-server/pull/142
```

Keep the summary to one line, present tense, no trailing punctuation.
