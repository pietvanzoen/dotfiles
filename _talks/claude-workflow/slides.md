%title:
%author: @pietvanzoen

->  ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗
-> ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝
-> ██║     ██║     ███████║██║   ██║██║  ██║█████╗  
-> ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝  
-> ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗
->  ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝╚══════╝

-> A development workflow built on Claude Code.

-> ᕕ( ᐛ )ᕗ

---

-> What we'll cover
===

* claude-sessions dashboard
* parallel work with worktrees
* the task workflow
* custom skills & hooks
* statusline

---

-> claude-sessions
===

* live dashboard across all active Claude sessions
* columns: PROJECT · BRANCH · STATUS · STAGE · NEXT · LAST ACTIVE
* color-coded workflow stages (planning → dev → pr → cleanup)
* clickable PR hyperlinks, dirty indicators, last active age
* `claude-sessions --watch` for live 5s refresh

---

-> .claude-notes
===

_the file that feeds the dashboard_

```
prompt: implement the export button
stage: dev
fixed ESLint errors in ExportModal.tsx
next: add unit tests
pr: #142 open https://github.com/...
```
* written by Claude after each response via `/notes`
* refreshed automatically by the Stop hook after every reply
* one file per project — persists across sessions

---

-> Worktrees
===

_one branch · one worktree · one Claude session_

* no stashing, no branch switching, no conflicts
* `git worktree add ../project-feat feature/my-feature`
* each worktree has its own `.claude-notes`
* `git done` — tears down worktree + branch + tmux window post-merge
* `claude-sessions --prune-merged` — bulk cleanup

---

-> Task Workflow
===

* 1. branch setup — create or switch branch
* 2. context — tickets, bugs, switch to Opus for planning
* 3. planning — propose approach, get approval, switch to Sonnet
* 4. development — TDD, lint, commit via `/commit`
* 5. PR — open PR, self-review, request Copilot
* 6. review — address comments, push updates
* 7. merge — `/merge` → revise CLAUDE.md → squash on GitHub

---

-> Custom Skills
===

* `/commit` — groups diffs, runs linter, writes focused messages
* `/notes` — updates `.claude-notes` with stage + next step
* `/merge` — revise CLAUDE.md → verify checks → `gh pr merge --squash`
* `/status` — branch status, ahead/behind, pending changes

---

-> Hooks & Statusline
===

## Hooks fire on Claude lifecycle events:
* prompt submit → adds ⏺ to tmux window name
* stop → macOS "Done" notification · removes ⏺ · refreshes PR info
* elicitation → "Has a question for you" alert

## Statusline (bottom of Claude Code):
`dotfiles  main*↑  • dev › run ./update •  sonnet  $0.12`

---

-> ┏━╸╻┏┓╻
-> ┣╸ ┃┃┗┫
-> ╹  ╹╹ ╹

-> github.com/pietvanzoen/dotfiles

---
