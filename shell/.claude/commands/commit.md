---
name: commit
description: Create a Git commit
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(yarn * lint *), Bash(gh pr view *)
---

Create git commits for the current changes.

1. Run `git status` and `git diff` to review all staged and unstaged changes
2. Run `git log --oneline -5` to see recent commit style
3. Group changes into logical commits — if changes span unrelated concerns (e.g. a feature + a refactor, or changes to different subsystems), create separate commits for each
4. For each logical group, check if it clearly belongs to an existing recent commit (e.g. same feature, same file, continuation of same work). If so:
   - **Most recent commit**: amend with `git commit --amend --no-edit`
   - **Older commit**: create a fixup commit with `git commit --fixup=<sha>`, then rebase to apply it:
     `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash $(git merge-base HEAD main)`
5. For new commits:
   a. Stage only the relevant files (prefer specific files over `git add -A`)
   b. Run lint --fix for affected workspaces before committing
   c. Write a concise commit message that focuses on the "why" not the "what"
   d. Create the commit using a HEREDOC for the message
6. Run `git status` to verify

Important:
- NEVER prefix commands with `cd <path> &&`. Run all git and lint commands directly — they will automatically use the current working directory. Git commands work from any subdirectory of a repo.
- Do not use pipes or chain multiple unrelated commands. Use separate tool calls instead.
- Do not push to remote unless explicitly asked.
