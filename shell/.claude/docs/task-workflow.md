# Task Workflow

When starting a new task, guide the user through these steps and proactively suggest
the next action:

1. **Planning**
   - Check the current branch name for a Linear ticket ID (e.g. `feat/ENG-123-some-description`)
   - If no ticket is apparent, ask: "Are there any tickets or bugs related to this task?"
   - Gather and reference ticket IDs and bug reports
   - Present **three solution options** with tradeoffs:
     - **Option A — Pragmatic**: fastest path; acceptable shortcuts, known tradeoffs
     - **Option B — Balanced**: reasonable effort, good correctness
     - **Option C — Correct**: proper solution; more work but fewest future problems
   - Each option gets a one-line tradeoff summary. End with a **recommended option** and rationale
   - **Always end plans with a bold recommended model**, e.g.:
     **> Recommended model for implementation: Sonnet (Opt+P)**
   - If a Linear ticket exists, update its description with the accepted plan: preserve any
     existing description, add a horizontal rule (`---`), and append the plan below it
   - After plan is accepted, suggest switching to a lower model for implementation
     (Sonnet for multi-file work, Haiku for simple edits)
   - Ensure the plan file contains enough detail (file paths, function signatures, key decisions)
     that a lower model can execute complex implementation without re-deriving context

2. **Development**
   - Follow TDD workflow if writing tests
   - Make changes incrementally
   - Run linter/formatter before committing
   - Run tests to verify functionality
   - Commit work with clear messages

3. **PR + review**
   - Open a **draft PR** via `/pr` (creates draft, requests Copilot review)
   - Run `/review-pr` (pr-review-toolkit) for self-review; fix any issues found, push
   - Use `/loop` to poll for Copilot review (~270s interval, stays in prompt cache):
     - Check: `gh api repos/{owner}/{repo}/pulls/{pr}/reviews` for a completed review
     - When review lands: assess comments, implement fixes, push
     - Reply to comments per CLAUDE.md format (prefixed with `> _Posted by Claude Code_`)
     - Do NOT resolve comments — the user resolves them in the GitHub UI
   - After fixes pushed, poll for CI checks:
     - Check: `gh pr view --json statusCheckRollup`
     - If checks fail, diagnose and fix

4. **Human review**
   - Mark the PR as ready for review: `gh pr ready`
   - Request reviewers
   - **Stop and wait** — do not merge without human approval

5. **Cleanup**
   - After the PR is merged, suggest running `/revise-claude-md` to capture any
     learnings from the session into CLAUDE.md

**At each step:**
- Indicate the current step in the workflow
- Complete the current step's actions
- Explicitly suggest the next step
- Only merge requires user confirmation — other steps proceed autonomously in auto-mode
