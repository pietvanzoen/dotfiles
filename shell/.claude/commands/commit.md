---
name: commit
description: Create a Git commit
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh pr view *)
---

# Create Git Commit

<current_branch>
!`git branch --show-current`
</current_branch>

<working_tree_status>
!`git status --short`
</working_tree_status>

<staged_diff>
!`git diff --cached`
</staged_diff>

<unstaged_diff>
!`git diff`
</unstaged_diff>

<recent_commits>
!`git log --oneline -5`
</recent_commits>

## Pre-flight check

If `working_tree_status` is empty, stop and inform the user there's nothing to commit.

## Step 1 — Create commits

1. Group changes into logical commits — if changes span unrelated concerns (e.g. a feature + a refactor, or changes to different subsystems), create separate commits for each
2. For each logical group, check if it clearly belongs to an existing recent commit (e.g. same feature, same file, continuation of same work). If so:
   - **Most recent commit**: amend with `git commit --amend --no-edit`
   - **Older commit**: create a fixup commit with `git commit --fixup=<sha>`, then rebase to apply it:
     `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash $(git merge-base HEAD main)`
3. For new commits:
   a. Stage only the relevant files (prefer specific files over `git add -A`)
   b. Write a concise commit message that focuses on the "why" not the "what"
   c. Create the commit using a HEREDOC for the message
4. Run `git status` to verify

## Rules

- NEVER prefix commands with `cd <path> &&`. Run all git and lint commands directly — they will automatically use the current working directory. Git commands work from any subdirectory of a repo.
- Do not use pipes or chain multiple unrelated commands. Use separate tool calls instead.
- Do not push to remote unless explicitly asked.
