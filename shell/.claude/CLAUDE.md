@~/.claude/CLAUDE.cutr.md

## Session notes
Run `/notes` as the **last action in every response**. Skip only for trivial replies
(acknowledgements, clarifications, short answers with no code changes).

Run in background with a single Bash call — use `run_in_background: true` and do NOT add `&` or redirections to the command string itself:
```
Bash(claude-notes-update --stage dev "<done> → <next step>", run_in_background: true)
```
Be detailed — include file names, ticket IDs, feature names. No trailing punctuation.
Keep the `<next step>` part to **40 characters or fewer** where possible — it maps to a fixed-width column in the sessions dashboard.

Include `--stage` only when the workflow stage changes (not on every update). Valid stages:
`setup` · `context` · `planning` · `dev` · `pr` · `review` · `human-review` · `cleanup`

## Session start
At the beginning of each new session, display this shortcuts reminder:

```
Shortcuts: !cmd (shell) | @file (mention) | Ctrl+R (history) | Shift+Tab (mode) | Ctrl+B (background)
           Opt+P (model) | Opt+T (thinking)
Commands:  /vim | /cost | /diff | /status | /compact | /help
```

## Text width
Wrap prose text at 120 characters per line. Apply this to explanations, plans,
and any multi-sentence text output. Do not wrap code blocks or tool output.

## Response status
End each response with a one-line status summary so the user can quickly regain context when switching between sessions:

> **[current task] → [next step]** `HH:MM`

Include the current time in HH:MM format (24-hour) to track when work was done.

## Model usage
After reviewing any tickets/bugs in context gathering (step 2 of Task Workflow), suggest switching to an appropriate model based on task complexity:
- **Sonnet** is sufficient for: reading/explaining code, simple edits, git operations, writing docs, answering questions
- **Haiku** is sufficient for: quick lookups, single-file edits, running commands, short Q&A
- **Opus** is warranted for: complex multi-file refactors, architectural decisions, hard bugs, nuanced reasoning

Include a prominent model suggestion, e.g.:
**> Switch to Haiku (Opt+P) — this task doesn't need Sonnet.**

## TDD
- Follow TDD when writing tests: one test at a time, red-green-refactor
  1. Write a single failing test
  2. Run it — confirm it fails for the expected reason
  3. Write the minimum implementation to make it pass
  4. Run it — confirm it passes
  5. Repeat from step 1 for the next test
- Once all tests pass, suggest refactoring improvements to remove duplication in both tests and implementation
- Do NOT write multiple tests at once or implement ahead of the current test
- Never use "should" at the beginning of test descriptions. E.g. BAD it('should return wibble'). GOOD it('returns wibble')

## Fixes and debugging

When fixing a failing test or build error, always explain the root cause before
proposing a fix. Do NOT apply workarounds that suppress symptoms without explicit
user approval, including:
- Increasing memory or timeout limits
- Adding @ts-ignore, eslint-disable, or @SuppressWarnings
- Commenting out or skipping failing assertions or tests
- Catching and swallowing exceptions

If the correct fix is unclear, say so and ask rather than patching around the problem.

## Context management

When a session grows long or the task scope shifts significantly, suggest running
/compact or starting a fresh session. Long accumulating context degrades output
quality — prefer shorter focused sessions over one long running one.

Do not load large files or entire codebases into context unless directly needed for
the current step. Include relevant modules only.

## Tmux/Neovim
- Neovim runs in the `dev` tmux session. The window is named after the project directory.
- The current project's window name matches the basename of the working directory. Use that window, not just any nvim pane.
- Find the nvim pane for the current project: `tmux list-panes -t dev:<window_name> -F '#{session_name}:#{window_name}.#{pane_index} #{pane_current_command}' | grep nvim | head -1 | cut -d' ' -f1`
- To open files: `tmux send-keys -t <pane> ':e <path>' Enter`
- To open in vertical split: `tmux send-keys -t <pane> ':vs <path>' Enter`

## Pull requests
Use `/pr` to create a pull request. It handles push, title/description generation, and Copilot review assignment.

When asked to merge a PR: **ALWAYS wait for checks to pass**. Do not use admin override unless specifically instructed.

## PR review comments
When posting replies to GitHub PR review comments, always prefix the message with `> _Posted by Claude Code_` on its own line, followed by a blank line, before the reply body. This makes it clear the comment was AI-generated and not written by the user.

To reply **in a review thread** (not as a general PR comment), use:
`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies -X POST -f body="..."`
Note: the URL must include the PR number — `pulls/{pr}/comments/{id}/replies`, NOT `pulls/comments/{id}/replies`.

**Reading inline review comments:** `gh pr view --comments` silently omits line-level (inline) code review comments —
it only shows general PR comments. To read inline comments, use:
`gh api repos/{owner}/{repo}/pulls/{pr}/comments`

## CLI script output
In CLI scripts (bash, python, etc.), prefix log/status lines with `==>` or `-->` rather than plain text or emoji.
Use `==>` for major steps and `-->` for sub-steps or progress within a step.

## Linting and formatting
Before committing code: **always run the project's linter/formatter if available**. Check for a lint command in the project (package.json, Makefile, pyproject.toml, etc.) and run it with auto-fix flags before staging commits.

## Git commands
Run git commands as separate tool calls, one at a time. Never chain them with `&&` or `;` in a single Bash call. This keeps the activity history clear and readable in the output, and makes it easier to see the progression of changes.

Never use `git -C /absolute/path` when the shell's cwd is already the correct directory — use plain `git add`, `git commit`, etc. instead. Explicit paths trigger extra permission prompts for no benefit.

## Task Workflow
When starting a new task, read `~/.claude/docs/task-workflow.md` for the workflow steps.