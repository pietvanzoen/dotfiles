---
name: pr
description: Create a GitHub pull request
allowed-tools: Bash(git *), Bash(gh *), Bash(jq *)
model: haiku
---

# Create Pull Request

<current_branch>
!`git branch --show-current`
</current_branch>

<branch_status>
!`git status --short`
</branch_status>

<commits_on_branch>
!`git log main..HEAD --oneline`
</commits_on_branch>

<commit_details>
!`git log main..HEAD --pretty=format:"### %s%n%n%b%n---"`
</commit_details>

<diff_stat>
!`git diff main..HEAD --stat`
</diff_stat>

## Pre-flight checks

1. **Uncommitted changes** — if `branch_status` is non-empty, stop and ask the user to commit first
2. **Not on main** — if `current_branch` is `main` or `master`, stop and inform the user
3. **Existing PR** — run `gh pr view --json number,title,state,url` to check; if a PR exists, show the URL and stop
4. **Lint and format** — detect and run the project's linter/formatter with auto-fix if available:
   - Check `package.json` for scripts named `lint`, `lint:fix`, `format`, or `fmt`; prefer `lint:fix` and `format` (auto-fixing variants)
   - Fall back to well-known binaries: `make lint`, `eslint --fix`, `prettier --write`, `biome check --write`, `ruff check --fix && ruff format`, `black .`, `golangci-lint run`
   - If auto-fix runs and produces changes, stop and ask the user to review and commit the fixes before continuing

## Write the title

**Format:** `<type>(<scope>): <description>`

- `<scope>` is the Linear ticket ID when available (check `current_branch` for pattern `[A-Z]+-[0-9]+`, e.g. `CUT-123`); omit scope if no ticket
- `<type>`: `feat`, `fix`, `docs`, `refactor`, `chore`, `perf`, `test`, `ci`
- Imperative mood, ≤ 70 characters total
- Describe the **outcome**, not the implementation

Examples:
- `feat(CUT-123): add partlist template export`
- `fix(CUT-456): resolve race condition on save`
- `chore: upgrade Node to 22`

## Write the description

Keep it short. The commit log is already part of the PR — don't repeat it.

```markdown
## Why

<1–3 sentences: motivation or problem being solved. Omit entirely if the title and
commits tell the story.>

## Test plan

- [ ] <manual step or automated test>
- [ ] <edge case, if non-obvious>

<Omit test plan entirely for trivial changes (docs, config, typos).>
```

**Don'ts:**
- No "Changes" or "What" section — that's what commits are for
- No bullet list restating what files were modified
- No filler like "This PR introduces…"

## Push and create

**Single-commit branch** — use `--fill-first` to auto-populate from the commit:
```bash
git push -u --force-with-lease
gh pr create --draft --fill-first
```

**Multi-commit branch** — craft title and body manually:
```bash
git push -u --force-with-lease
gh pr create --draft --title "<title>" --body "$(cat <<'EOF'
<body>
EOF
)"
```

Then request Copilot review:
```bash
PR_NUMBER=$(gh pr view --json number | jq -r '.number')
REPO=$(gh repo view --json nameWithOwner | jq -r '.nameWithOwner')
gh save-me-copilot "$REPO" "$PR_NUMBER" > /dev/null 2>&1
```

Print the PR URL.
