## Session start
At the beginning of each new session, display this shortcuts reminder:

```
Shortcuts: !cmd (shell) | @file (mention) | Ctrl+R (history) | Shift+Tab (mode) | Ctrl+B (background)
           Opt+P (model) | Opt+T (thinking)
Commands:  /vim | /cost | /diff | /status | /compact | /help
```

## Response status
End each response with a one-line status summary so the user can quickly regain context when switching between sessions:

> **[current task] → [next step]**

Omit when the conversation is idle or the task is fully complete.

## Model usage
At the start of a session, suggest switching to a lighter model if the task doesn't need Opus:
- **Sonnet** is sufficient for: reading/explaining code, simple edits, git operations, writing docs, answering questions
- **Haiku** is sufficient for: quick lookups, single-file edits, running commands, short Q&A
- **Opus** is warranted for: complex multi-file refactors, architectural decisions, hard bugs, nuanced reasoning

Remind the user with a one-liner: e.g. _"This looks like a Sonnet task — switch with Opt+P to save cost."_

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
