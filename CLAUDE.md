@./CLAUDE.local.md

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
- After adding/removing Neovim plugins, commit `vim/.config/nvim/lazy-lock.json` alongside the plugin config change
- Git custom commands are named `git-<command>` in `git/.local/bin/`
- Use `*.example` suffix for files that contain placeholders for secrets

## Environment

- **Terminal**: Ghostty on macOS (config in `shell/.config/ghostty/config`)
- **Shell**: Zsh
- **Multiplexer**: tmux (config in `shell/.tmux.conf`)
- **Editor**: Neovim (Lua-based, lazy.nvim)

## Linting

- Run `make lint` before committing shell script changes
- Run `make lint FILES="path/to/script"` to check specific files
- ShellCheck config is in `.shellcheckrc`

## Shell aliases
- `cp` is aliased to `cp -vi` (interactive + verbose) — use `/bin/cp -f` to bypass when overwriting files non-interactively

## Script language selection / macOS gotchas
Use the `shell-scripting` agent when writing scripts or hitting macOS sed/redirect/stow quirks.

## ntfy testing
- `curl` is blocked by the permission system — use `node -e "fetch(...)"` to call the ntfy API
- `NTFY_TOKEN` and `NTFY_URL` env vars are set; server requires `Authorization: Bearer $NTFY_TOKEN`
- Poll latest message: `GET $NTFY_URL/claude/json?poll=1&since=latest` with auth header
- Hooks use `--away-only` so they won't fire while screen is active — test by posting to the API directly

## Committing code

Never auto-commit without prompting. Always stage changes and wait for user to run `/commit` before finalizing.
- Propose changes and ask if they should be committed
- Wait for explicit `/commit` command — don't proceed without it
- This ensures changes are intentional and reviewed

## Workflow

After creating new files that need to be stowed (executables, configs, etc.), run:

```bash
make update
```

This restows all packages and creates the necessary symlinks in `$HOME`.
Also run `make update` after renaming or moving stowed files to fix symlinks.
- New stow packages need an entry in `.installed_packages` (git-ignored) before `make update` will stow them

## Neovim LSP gotchas
- `root_dir` functions receive a buffer number (not a path) during session restore — always guard `vim.fn.readfile(fname)` with `if vim.fn.filereadable(fname) ~= 1 then return end`

## tmux / Ghostty gotchas
Use the `tmux-config` agent when editing `.tmux.conf`, format strings, key bindings, or Ghostty config.