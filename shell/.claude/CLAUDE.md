## Session start
At the beginning of each new session, display this shortcuts reminder:

```
Shortcuts: !cmd (shell) | @file (mention) | Ctrl+R (history) | Shift+Tab (mode) | Ctrl+B (background)
Commands:  /vim | /cost | /diff | /status | /compact | /help
```

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
