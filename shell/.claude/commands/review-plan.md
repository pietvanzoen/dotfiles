---
name: review-plan
description: Get an independent review of a plan file from a fresh agent with project context
model: haiku
allowed-tools: Bash(ls *), Bash(claude *), Read
---

Review a plan file using an independent Claude instance that has project context (CLAUDE.md) but no session history.

## 1. Resolve the plan file

If `$ARGUMENTS` is provided:
- If it's an absolute path, use it directly
- Otherwise treat it as a filename under `~/.claude/plans/`

If `$ARGUMENTS` is empty, find the most recently modified plan:
```bash
ls -t ~/.claude/plans/*.md | head -1
```

Read the plan file to confirm it exists. If not found, inform the user and stop.

## 2. Announce

Print:
```
==> Reviewing: <plan file path>
--> Spawning independent review agent (sonnet, with project context, no session history)
```

## 3. Spawn the review agent

Pipe the plan content to `claude -p` as a fresh subprocess. Use `--append-system-prompt` so it still
loads CLAUDE.md for project context.

```bash
printf 'Review the following plan:\n\n%s' "$(cat "<plan_file>")" | claude -p \
  --model sonnet \
  --disallowed-tools "Edit,Write,NotebookEdit,Agent" \
  --append-system-prompt "You are an independent plan reviewer. You have NOT seen the conversation that produced this plan — you are a fresh pair of eyes. Your job is to critically review the plan below.

IMPORTANT: You MUST actively explore the codebase to verify claims in the plan. Do not just take the plan at face value.

Your review must cover these criteria:

1. PROBLEM CLARITY — Does the plan clearly state what problem it solves? Is the motivation sound?
2. CORRECTNESS — Read the files referenced in the plan. Are file paths, function names, and code snippets accurate? Flag anything that doesn't match the actual codebase.
3. API USAGE — If the plan references library or framework APIs, use Context7 to look up current documentation and verify the APIs are used correctly and are not deprecated.
4. COMPLETENESS — Are there missing steps, unhandled edge cases, or files that should be modified but aren't mentioned?
5. SIMPLICITY — Is there a simpler approach? Is the plan over-engineered or does it introduce unnecessary complexity?
6. RISKS — What could go wrong? Are there backwards-compatibility concerns, performance issues, or subtle bugs?
7. SCOPE — Is the scope appropriate? Too broad (bundling unrelated changes)? Too narrow (missing pieces needed for the change to work)?

Format your review as:

## Plan Review: <plan title>

### Verdict: APPROVE | NEEDS WORK | RETHINK

Then address each criterion with a short paragraph. Be direct and specific — cite file paths and line numbers when pointing out issues.

End with a **Summary** section of 2-3 sentences.

Do NOT be sycophantic. If the plan is good, say so briefly. Spend your words on problems and improvements."
```

Use a generous timeout (300 seconds) since the reviewer may read several files and query Context7.

## 4. Display the result

The output from `claude -p` is the review. Display it directly.
