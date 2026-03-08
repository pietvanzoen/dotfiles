---
name: status
description: Show git status overview — working tree, upstream, and branch commits
disable-model-invocation: true
allowed-tools: Bash(git *)
---

Show a concise git status overview. Run these commands in parallel:

1. `git status -s` — working tree changes
2. `git lb` — commits on current branch that diverge from origin trunk (equivalent to `git log --graph --oneline origin/<trunk>..HEAD`)
3. `git rev-parse --abbrev-ref HEAD` and upstream ahead/behind with `git rev-list --left-right --count @{upstream}...HEAD`

Present the output grouped under clear headings: Branch, Upstream, Changes, and Branch Commits.
If there are no changes or no branch commits, say so briefly.
