# Dotfiles

## Security

This is a **public repository**. Never commit secrets, credentials, API keys, tokens, or private configuration. Files matching `*.example` are templates that get copied locally during install — put sensitive values there, not in tracked files.

## Structure

This repo uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink dotfiles into `$HOME`. Each top-level directory (except those prefixed with `_`) is a stow package:

- `git/` — Git config, global gitignore, custom git commands in `.local/bin/`
- `shell/` — Zsh config, tmux, aliases, Claude Code settings
- `vim/` — Neovim config (Lua-based, uses lazy.nvim)
- `macos/` — macOS-specific settings
- `_scripts/` — Bootstrap and install scripts (not stowed)
- `_gnupg/` — GPG setup (not stowed)

Files are stowed relative to `$HOME`, so `git/.gitconfig` becomes `~/.gitconfig`.

## Conventions

- Custom shell scripts go in `<package>/.local/bin/` (stowed to `~/.local/bin/`)
- Shell libraries go in `<package>/.local/lib/` (stowed to `~/.local/lib/`)
- Neovim plugin configs go in `vim/.config/nvim/lua/plugins/`
- Git custom commands are named `git-<command>` in `git/.local/bin/`
- Use `*.example` suffix for files that contain placeholders for secrets

## Environment

- **Terminal**: iTerm2 on macOS
- **Shell**: Zsh
- **Multiplexer**: tmux (config in `shell/.tmux.conf`)
- **Editor**: Neovim (Lua-based, lazy.nvim)

## Linting

- Run `make lint` before committing shell script changes
- Run `make lint FILES="path/to/script"` to check specific files
- ShellCheck config is in `.shellcheckrc`

## macOS shell scripting gotchas

- `sed -i '' -e 'expr' file` exits 2 with "can't read : No such file" on macOS even when the edit succeeds — use `sed -i''` (no space) instead
- Check `shell/.local/lib/aliases.sh` for alias conflicts before naming new scripts in `~/.local/bin/`
- If a newly stowed command isn't found, ask the user to reload their shell (`exec zsh`) — don't work around it by using the full `~/.local/bin/` path

## Script language selection

- **Bash**: simple glue — invoking commands, file ops, < ~50 lines, no structured data
- **Node.js**: complex logic — HTTP, JSON, async, structured data, anything > ~50 lines of bash
  - Shebang: `#!/usr/bin/env node` (CommonJS `require`, no build step)
  - Avoid `node_modules` where possible; prefer built-in `fetch`/`fs`/`readline` (Node ≥ 18)
  - `node` is available in all shells via `~/.zshenv` PATH fix
- **Python**: only for existing scripts (e.g. `claude-sessions`); don't start new scripts in Python
- **Deno/Bun/zx**: don't introduce new runtimes without discussion

## Workflow

After creating new files that need to be stowed (executables, configs, etc.), run:

```bash
make update
```

This restows all packages and creates the necessary symlinks in `$HOME`.
Also run `make update` after renaming or moving stowed files to fix symlinks.