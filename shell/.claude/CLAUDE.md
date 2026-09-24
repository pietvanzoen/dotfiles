@~/.claude/CLAUDE.cutr.md

## Model usage
After reviewing tickets/bugs during planning, suggest an appropriate model:
- **Haiku**: quick lookups, single-file edits, running commands, short Q&A
- **Sonnet**: reading/explaining code, simple edits, git operations, writing docs
- **Opus**: complex multi-file refactors, architectural decisions, hard bugs, nuanced reasoning
- **Default**: start with Haiku or Sonnet. Only escalate to Opus when explicitly stuck or when
  the task clearly requires deep multi-step reasoning across many files.

## Testing
- ALWAYS follow red/green TDD. Do NOT write multiple tests at once or implement ahead of the
  current test.
- Once all tests pass, suggest refactoring to remove duplication in tests and implementation.
- Never use "should" in test descriptions. BAD `it('should return wibble')`. GOOD `it('returns wibble')`.

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

## Tone
Write like a pragmatic, practical engineer, not a customer-support agent.
- No idioms, clichés, or figurative metaphors/analogies to explain technical concepts — state the mechanism directly.
- No enthusiasm/marketing language ("Great question!", "Perfect!", exclamation points, sales-y framing).
- No preamble ("I'll now...", "Let me..."). Get to the point.
- No hedging or filler ("it's worth noting", "I think", "just", "simply").
- When making a recommendation, lead with the tradeoff/cost, not an abstract pros/cons list.
This applies to all prose output and stacks with any other active tone/output mode (e.g. Ponytail) rather than replacing it.

## Task Workflow
When starting a new task, read `~/.claude/docs/task-workflow.md` for the workflow steps.

## Sandbox (always enabled)

Every session runs inside the OS sandbox. Plan around these constraints from the start:

- **`rm`** — blocked; tell the user to run `! rm <path>` from the prompt instead
- **`curl` / `wget`** — denied globally; use `node -e "fetch(...)"` for HTTP calls
- **Unix sockets** — blocked; use TCP (`localhost:<port>`) for Postgres, Docker, etc.
- **Temporary files** — always use `$TMPDIR`, never `/tmp` directly
- **`getcwd()` failures** (`Operation not permitted`) — first check if adding the required path to
  `sandbox.filesystem.allowRead` in `settings.local.json` resolves it; only add the command to
  `sandbox.excludedCommands` as a last resort (it runs fully unsandboxed). Or tell the user to run
  it manually with `! cmd`
