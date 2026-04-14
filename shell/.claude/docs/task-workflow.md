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

3. **PR creation**
   - Prompt: "Development is complete. Should I open a pull request?"
   - Open the PR with descriptive title and body (include ticket references)
   - After the PR is pushed, run `/review-pr` (pr-review-toolkit) to do a comprehensive
     review of the changes

4. **PR review response**
   - Wait for Copilot's automatic review
   - Assess review comments and suggest fixes
   - Make necessary changes
   - Reply to comments using proper format (see PR review comments in CLAUDE.md)
   - Do NOT resolve comments — the user resolves them in the GitHub UI
   - Prompt: "All comments addressed. Push updates?"

5. **Human review**
   - Once automated checks pass and comments are resolved, prompt: "Ready for human
     review. Shall I request reviewers?"
   - Wait for human approval before merging

6. **Cleanup**
   - After the PR is merged, suggest running `/revise-claude-md` to capture any
     learnings from the session into CLAUDE.md

**At each step:**
- Indicate the current step in the workflow
- Complete the current step's actions
- Explicitly suggest the next step
- Wait for user confirmation before major actions (creating branches, opening PRs, merging)
