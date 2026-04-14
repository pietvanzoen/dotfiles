@~/.claude/CLAUDE.cutr.md

## Text width
Wrap prose text at 120 characters per line. Apply this to explanations, plans,
and any multi-sentence text output. Do not wrap code blocks or tool output.

## Response status
End each response with a one-line status summary so the user can quickly regain context when switching between sessions:

> **[current task] → [next step]**

## Model usage
After reviewing tickets/bugs during planning, suggest an appropriate model:
- **Haiku**: quick lookups, single-file edits, running commands, short Q&A
- **Sonnet**: reading/explaining code, simple edits, git operations, writing docs
- **Opus**: complex multi-file refactors, architectural decisions, hard bugs, nuanced reasoning

## TDD
- Follow TDD: one test at a time, red-green-refactor. Do NOT write multiple tests at once or implement ahead of the
  current test.
- Once all tests pass, suggest refactoring to remove duplication in tests and implementation.
- Never use "should" in test descriptions. BAD `it('should return wibble')`. GOOD `it('returns wibble')`.

## Tmux/Neovim
- Neovim runs in the `dev` tmux session. Window name matches the project directory basename.
- Open files: `nvim-open /absolute/path/to/file` (defaults to vsplit; `--tab` for new tab)

## Pull requests
Use `/pr` to create a pull request. It handles push, title/description generation, and Copilot review assignment.

When asked to merge a PR: **ALWAYS wait for checks to pass**. Do not use admin override unless specifically instructed.

## PR review comments
Prefix all PR comment replies with `> _Posted by Claude Code_\n\n` before the body.

Reply in a review thread (not general PR comment):
`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies -X POST -f body="..."`

Read inline comments (`gh pr view --comments` omits them):
`gh api repos/{owner}/{repo}/pulls/{pr}/comments`

## CLI script output
In CLI scripts (bash, python, etc.), prefix log/status lines with `==>` or `-->` rather than plain text or emoji.
Use `==>` for major steps and `-->` for sub-steps or progress within a step.

## Linting and formatting
Before committing: always run the project's linter/formatter (if available) with auto-fix before staging.

## Git commands
Run git commands as separate tool calls, one at a time. Never chain with `&&` or `;`.
Never use `git -C <path>` when cwd is already correct — triggers extra permission prompts.

## Commit signing
Commits are signed via 1Password, which requires interactive authentication and blocks when the user is away.
If `git commit` fails due to signing (op-ssh-sign error, exit code 1), retry with `--no-gpg-sign` **only when on
a feature branch**. Never skip signing on main/master. Squash merges replace branch commits, so branch signatures
are disposable.

## Task Workflow
When starting a new task, read `~/.claude/docs/task-workflow.md` for the workflow steps.