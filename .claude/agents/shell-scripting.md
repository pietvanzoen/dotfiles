---
name: shell-scripting
description: Use this agent when writing shell scripts, choosing a scripting language
  (Bash vs Node.js vs Deno), or hitting macOS-specific gotchas with sed, redirects,
  or stow commands.
---

## Script language selection

- **Bash**: simple glue — invoking commands, file ops, < ~50 lines, no structured data
- **Node.js**: complex logic — HTTP, JSON, async, structured data, anything > ~50 lines
  of bash
  - Shebang: `#!/usr/bin/env node` (CommonJS `require`, no build step)
  - Avoid `node_modules` where possible; prefer built-in `fetch`/`fs`/`readline` (Node ≥ 18)
  - `node` is available in all shells via `~/.zshenv` PATH fix
- **Python**: only for existing scripts (e.g. `claude-sessions`); don't start new scripts
  in Python
- **Deno**: acceptable for scripts that benefit from TypeScript or explicit permission
  flags; use scoped permissions (e.g. `--allow-net=api.example.com`) over broad ones
  - Shebang: `#!/usr/bin/env -S deno run --allow-...`
  - Use `deno check` for type checking

## macOS shell scripting gotchas

- `sed -i '' -e 'expr' file` exits 2 with "can't read : No such file" on macOS even
  when the edit succeeds — use `sed -i''` (no space) instead
- `cmd < file 2>/dev/null` does NOT suppress bash's "no such file" error for the
  redirect — use `cat file 2>/dev/null | cmd` instead (add `# shellcheck disable=SC2002`)
- Check `shell/.local/lib/aliases.sh` for alias conflicts before naming new scripts
  in `~/.local/bin/`
- If a newly stowed command isn't found, ask the user to reload their shell
  (`exec zsh`) — don't work around it by using the full `~/.local/bin/` path

## Nerd Font glyphs in scripts

Write/Edit tools silently drop **Nerd Font private-use-area glyphs and box-drawing
characters** — use Python file I/O for these specific files:
- `shell/.local/bin/claude-sessions` — contains Nerd Font glyphs and box-drawing chars
- Add to this list when a new file causes silent glyph loss
- Python pattern: `python3 -c "f='path'; c=open(f).read(); c=c.replace('old', 'new'); open(f,'w').write(c)"`

Common typographic Unicode (em dash, ellipsis, etc.) is fine with Edit/Write.
