@~/.claude/CLAUDE.local.md

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

> **[current task] → [next step]**

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

## Tmux/Neovim
- Neovim runs in the `dev` tmux session. The window is named after the project directory.
- The current project's window name matches the basename of the working directory. Use that window, not just any nvim pane.
- Find the nvim pane for the current project: `tmux list-panes -t dev:<window_name> -F '#{session_name}:#{window_name}.#{pane_index} #{pane_current_command}' | grep nvim | head -1 | cut -d' ' -f1`
- To open files: `tmux send-keys -t <pane> ':e <path>' Enter`
- To open in vertical split: `tmux send-keys -t <pane> ':vs <path>' Enter`

## Pull requests
When asked to merge a PR: **ALWAYS wait for checks to pass**. Do not use admin override unless specifically instructed.

## PR review comments
When posting replies to GitHub PR review comments, always prefix the message with `> _Posted by Claude Code_` on its own line, followed by a blank line, before the reply body. This makes it clear the comment was AI-generated and not written by the user.

To reply **in a review thread** (not as a general PR comment), use:
`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies -X POST -f body="..."`
Note: the URL must include the PR number — `pulls/{pr}/comments/{id}/replies`, NOT `pulls/comments/{id}/replies`.

## Linting and formatting
Before committing code: **always run the project's linter/formatter if available**. Check for a lint command in the project (package.json, Makefile, pyproject.toml, etc.) and run it with auto-fix flags before staging commits.

## Git commands
Run git commands as separate tool calls, one at a time. Never chain them with `&&` or `;` in a single Bash call. This keeps the activity history clear and readable in the output, and makes it easier to see the progression of changes.

## Task Workflow
When starting a new task, Claude should guide the user through these steps
and proactively suggest the next action:

1. **Branch setup**
   - Check current branch status
   - If not on a task-specific branch, prompt: "Should I create a new branch
     for this task, or switch to an existing one?"
   - Create/checkout the appropriate branch

2. **Context gathering**
   - Ask: "Are there any Linear tickets or Sentry bugs related to this
     task?"
   - Gather and reference ticket IDs and bug reports
   - If not already on Opus, suggest switching: planning benefits from
     Opus-level reasoning
   - Run `/notes` to document the task starting point

3. **Planning**
   - Present a plan outlining the approach
   - Discuss possible solutions and trade-offs
   - Get user approval before implementation
   - Update the Linear ticket description with the accepted plan: preserve
     any existing description, add a horizontal rule (`---`), and append
     the plan below it
   - Run `/notes` after plan is accepted
   - After plan is accepted, suggest switching to a lower model for
     implementation (Sonnet for multi-file work, Haiku for simple edits)

4. **Development**
   - Follow TDD workflow if writing tests
   - Make changes incrementally
   - Run linter/formatter before committing (see "Linting and formatting")
   - Run tests to verify functionality
   - Commit work with clear messages
   - Run `/notes` after commits

5. **PR creation**
   - Prompt: "Development is complete. Should I open a pull request?"
   - Open the PR with descriptive title and body (include ticket references)
   - Use Claude's built-in PR review skill to review the changes
   - Run `/notes` after PR is opened

6. **PR review response**
   - Wait for Copilot's automatic review
   - Assess review comments and suggest fixes
   - Make necessary changes
   - Reply to comments using proper format (see "PR review comments")
   - Do NOT resolve comments — the user resolves them in the GitHub UI
   - Prompt: "All comments addressed. Push updates?"

7. **Human review**
   - Once automated checks pass and comments are resolved, prompt: "Ready
     for human review. Shall I request reviewers?"
   - Wait for human approval before merging

8. **Cleanup**
   - After the PR is merged, suggest running `/revise-claude-md` to capture
     any learnings from the session into CLAUDE.md
   - Run `/notes` with `--stage cleanup`

**At each step, Claude should:**
- Indicate the current step in the workflow
- Complete the current step's actions
- Explicitly suggest the next step
- Wait for user confirmation before major actions (creating branches,
  opening PRs, merging)