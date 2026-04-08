---
name: merge
description: Capture CLAUDE.md learnings then merge the current PR via GitHub
allowed-tools: Bash(gh pr *), Bash(gh api *)
model: opus
---

Merge the current branch's pull request on GitHub. Follow these steps in order:

## 1. Run /revise-claude-md

Invoke the `/revise-claude-md` skill now to capture any session learnings into CLAUDE.md before the branch is gone.

## 2. Verify PR is ready to merge

Run `gh pr view --json number,title,state,mergeable,statusCheckRollup` and confirm:
- State is `OPEN`
- All required checks have passed (no failing checks)
- PR is mergeable

If checks are failing, inform the user and stop.
Pending checks are OK — `--auto` will queue the merge to happen once they pass.

## 3. Merge via GitHub

Run:
```
gh pr merge --squash --delete-branch --auto
```

This squash-merges on GitHub (no local git operations) and deletes the remote branch.
If checks are still pending, `--auto` enables auto-merge — GitHub will merge once all checks pass.

