# Setting up a new (or wiped) Mac

Full sequence for restoring this machine after "Erase All Content and
Settings" (or a fresh install). Do the pre-wipe checklist in
`dotfiles-private/_docs/reinstall-*.md` first — it captures things this repo
can't rebuild.

1. Connect to Wi-Fi, sign into the Apple ID, sign into the App Store (needed
   for `mas`).
2. `git clone https://github.com/pietvanzoen/dotfiles.git ~/dotfiles`
3. `cd ~/dotfiles && _scripts/bootstrap`
   - Installs Xcode CLT and Rosetta, Homebrew, runs `brew bundle`, installs
     Node via fnm, installs global npm packages, offers `make install`.
   - Say no to `Brewfile.extras` on a work-only setup; run it later with
     `brew bundle --file=_scripts/Brewfile.extras`.
4. Install the 1Password app from the Mac App Store or 1password.com, sign
   in, turn on Settings → Developer → "Use the SSH agent", then
   `op account add --address cutrai`.
5. If you said no to `make install` in step 3: `make install`.
6. `git clone git@github.com:pietvanzoen/dotfiles-private.git ~/dotfiles-private`
   then `~/dotfiles-private/install`.
7. `~/dotfiles-private/_scripts/local-files restore` to pull the
   `.local`/env files back from 1Password. Copy anything else from the
   pre-wipe checklist out of the Time Machine backup ("Browse Time Machine
   Backups" in Migration Assistant, or mount the backup and open `Latest`).
8. Sign in to the tools that don't sync through 1Password:
   - `gh auth login`
   - `gcloud auth login && gcloud auth application-default login`
   - `doppler login`
9. Open `nvim` once to let lazy.nvim and Mason install, then `vale sync`.
10. Clone `cutr-server` to `~/repos/github.com/cutr-dev/cutr-server`, restore
    its `.env.development.local` files (from step 7), then run
    `scripts/setup`. Turn off System Settings → General → AirPlay Receiver
    (it holds port 5000).
11. Once iCloud Drive has finished syncing `~/Documents`: open Alfred →
    Advanced → Syncing and point it at
    `~/Documents/Apps/Alfred Sync/`. Once Dropbox has synced
    `~/Dropbox/Apps`: re-run `shell/_install` to link Karabiner and rclone
    configs.

## What's not automated

- macOS System Settings (`defaults write` etc.) — nothing here captures
  those. Diff `defaults read` before/after changing a setting if you want to
  script one.
- Mac App Store purchases you no longer own — `mas` can't buy new apps, only
  reinstall ones already in your purchase history.
- App-specific data restored from Time Machine (TablePlus connections,
  Obsidian vaults, browser profiles, and similar) — copy it from
  `~/Library/Application Support/<app>` in the backup.
