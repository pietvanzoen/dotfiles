# Sandbox Guide

Claude Code sandbox provides OS-level isolation (Seatbelt on macOS, bubblewrap on Linux). **All tools** — Edit, Write, Read, and Bash — run inside a filesystem/network boundary. Reads and writes are restricted to the project directory by default, network access is limited to an allowlist, and all child processes inherit the same restrictions. Projects opt in to additional access via `settings.local.json`.

## Common errors and fixes

- **`getcwd: Operation not permitted`** — the command calls `getcwd()` which stats `~/`,
  blocked by the sandbox. Fix: add the command to `sandbox.excludedCommands`, or run it
  manually with `! cmd` in the Claude Code prompt
- **`No such file or directory` on paths outside cwd** — sandbox blocks reads beyond the
  project. Fix: add the path to `sandbox.filesystem.allowRead`
- **Network connection refused / timeout** — domain not in the allowlist. Fix: add the
  domain to `sandbox.network.allowedDomains` (in global settings)
- **Write denied outside cwd** — sandbox restricts writes to the project directory. Fix:
  add the path to `sandbox.filesystem.allowWrite` (rare — think twice before widening)

## Decision framework: exclude vs. allow-path

When a sandbox error occurs, walk through these questions:

1. Does it need to **read** outside the project? → add to `filesystem.allowRead`
2. Does it need to **write** outside the project? → add to `filesystem.allowWrite`
   (evaluate carefully — see threat check below)
3. Does it call **`getcwd()`** and break entirely in sandbox? → add to `excludedCommands`
4. Is it a **build tool** that spawns many subprocesses? → likely needs `excludedCommands`

### Threat check before allowing

Run every proposed exception through these two questions:

- **Data exfiltration** — could this command send file contents to a network endpoint?
  Examples: `curl`, `wget`, scripts using `fetch()`. If yes, keep it sandboxed — the
  network allowlist prevents it from reaching arbitrary hosts
- **Destructive edits** — could this command delete or overwrite files outside the
  project? Examples: `rm -rf`, `stow`, package installers. If yes, keep it sandboxed
  or scope the path as narrowly as possible

If neither risk applies (e.g. `make` calling `shellcheck`), excluding is safe.

## Project setup

Start with a minimal `settings.local.json` and widen only when you hit errors:

```json
{
  "sandbox": {
    "excludedCommands": [],
    "filesystem": {
      "allowRead": ["."]
    }
  }
}
```

- `allowRead: ["."]` lets sandbox read the project root (needed for most tools)
- Add `excludedCommands` entries one at a time as you encounter `getcwd` failures
- Review each addition against the threat check above before committing it

## Known incompatible tools

- **`make`** — calls `getcwd()` on startup; add to `excludedCommands`
- **`docker`** — needs Unix socket access (`/var/run/docker.sock`); add to
  `excludedCommands` or configure `filesystem.allowUnixSockets`
- **`watchman`** — incompatible with sandbox; use `--no-watchman` flag where possible
  (e.g. `jest --no-watchman`)

## Sandbox and permissions

With sandbox enabled, most explicit `Bash(...)` permission allows are redundant — the
sandbox already contains commands within the filesystem/network boundary without
prompting. Keep explicit allows only for:

- Non-Bash tools: `WebSearch`, `WebFetch(...)`, MCP tools, `Skill(...)`
- `Read(...)` paths outside the project that sandbox doesn't cover
- Commands in `excludedCommands` run unsandboxed and may still need explicit allows
  depending on your permission mode
