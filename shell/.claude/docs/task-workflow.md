# Task Workflow

When starting a new task, guide the user through these steps and proactively suggest
the next action:

1. **Branch setup**
   - Check current branch status
   - If not on a task-specific branch, prompt: "Should I create a new branch
     for this task, or switch to an existing one?"
   - Create/checkout the appropriate branch

2. **Context gathering**
   - Ask: "Are there any tickets or bugs related to this task?"
   - Gather and reference ticket IDs and bug reports
   - If not already on Opus, suggest switching: planning benefits from Opus-level reasoning
   - Run `/notes` to document the task starting point

3. **Planning**
   - Present a plan outlining the approach
   - Discuss possible solutions and trade-offs
   - **Always end plans with a bold recommended model**, e.g.:
     **> Recommended model for implementation: Sonnet (Opt+P)**
   - Get user approval before implementation
   - Plans must include an explicit **Out of scope** section listing files, APIs, and
     behaviours that must not be changed.
   - Plans must include a **Rollback plan**: how to revert the change if needed. This
     should inform design choices — prefer reversible changes.
   - If a Linear ticket exists, update its description with the accepted plan: preserve any
     existing description, add a horizontal rule (`---`), and append the plan below it
   - Run `/notes` after plan is accepted
   - After plan is accepted, suggest switching to a lower model for implementation
     (Sonnet for multi-file work, Haiku for simple edits)

4. **Development**
   - Follow TDD workflow if writing tests
   - Make changes incrementally
   - Run linter/formatter before committing
   - Run tests to verify functionality
   - **Never accept "tests pass" on trust** — always verify actual runner output. If
     tests are skipped, pending, or erroring in setup, treat this as a failing gate.
   - Do not proceed to the next step if any gate has been bypassed (e.g. --force,
     skipped tests, or @ignore annotations added during this session).
   - When starting each plan step, explicitly list the files in scope: "Implement only
     step N. Files allowed: [list]. Do not modify anything outside this list."
   - If a change requires touching out-of-scope files, stop and flag it rather than
     proceeding.
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
   - Reply to comments using proper format (see PR review comments in CLAUDE.md)
   - Do NOT resolve comments — the user resolves them in the GitHub UI
   - Prompt: "All comments addressed. Push updates?"

7. **Human review**
   - Once automated checks pass and comments are resolved, prompt: "Ready for human
     review. Shall I request reviewers?"
   - Wait for human approval before merging

8. **Cleanup**
   - After the PR is merged, suggest running `/revise-claude-md` to capture any
     learnings from the session into CLAUDE.md
   - Run `/notes` with `--stage cleanup`

**At each step:**
- Indicate the current step in the workflow
- Complete the current step's actions
- Explicitly suggest the next step
- Wait for user confirmation before major actions (creating branches, opening PRs, merging)
