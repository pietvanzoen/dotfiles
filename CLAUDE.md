@./CLAUDE.local.md

# Dotfiles

**Public repository** — never commit secrets. Use `*.example` files for templates containing placeholders.

## Structure

GNU Stow-based: each top-level directory (except `_*` prefixes) is a stow package symlinked into `$HOME`.

- `git/` — global config, gitignore, custom commands in `.local/bin/git-*`
- `shell/` — zsh, tmux, aliases, Ghostty config
- `vim/` — Neovim (Lua, lazy.nvim)
- `macos/` — OS-level settings
- `_scripts/` — bootstrap/install (not stowed)
- `_gnupg/` — GPG setup (not stowed)
- `stow/` — always installed first by `_scripts/install`

## Critical workflows

**After creating/moving stowed files**: `make update` (restows packages, fixes symlinks)

**New packages**: Add to `.installed_packages` before `make update` will stow them

**Linting shell scripts**: `make lint` before committing (ShellCheck config: `.shellcheckrc`)
- Lint specific files: `make lint FILES="path/to/script"`

**Neovim plugins**: After adding/removing plugins in `lua/plugins/`, commit `lazy-lock.json` alongside the change

## File placement conventions

- Executables → `<pkg>/.local/bin/` (stows to `~/.local/bin`)
- Shell libraries → `<pkg>/.local/lib/` (sourced by `.zshrc`)
- Neovim plugins → `vim/.config/nvim/lua/plugins/`
- Git custom commands → `git/.local/bin/git-<command>`
- Secrets/local overrides → `*.example` suffix (copied without suffix during install)

## Known gotchas

**Shell aliases**: `cp` is aliased to `cp -vi` (interactive) — use `/bin/cp -f` for non-interactive overwrites

**Shell scripting & macOS quirks**: Before writing shell scripts or hitting BSD sed/stow issues, read `docs/shell-scripting.md`

**ntfy API testing**: `curl` blocked by macOS permissions — use `node -e "fetch(...)"` instead
- Env vars: `NTFY_TOKEN`, `NTFY_URL` (server requires `Authorization: Bearer $NTFY_TOKEN`)
- Hooks use `--away-only` flag — test by posting directly to API

**Neovim LSP `root_dir`**: Receives buffer number (not path) during session restore
- Always guard file reads: `if vim.fn.filereadable(fname) ~= 1 then return end`

**tmux/Ghostty config**: Before editing `.tmux.conf` or Ghostty config, read `docs/tmux-config.md`

## Install flow

1. `_scripts/bootstrap` — installs dependencies
2. `_scripts/install` — interactive package selection, copies `*.example` files, runs package-specific `_install` scripts, stows selected packages
3. Selections recorded in `.installed_packages` (git-ignored)

## Private dotfiles

Machine-specific or private config lives in `~/dotfiles-private` (see `CLAUDE.local.md`)