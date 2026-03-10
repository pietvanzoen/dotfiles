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

## Workflow

After creating new files that need to be stowed (executables, configs, etc.), run:

```bash
./update
```

This restows all packages and creates the necessary symlinks in `$HOME`.
