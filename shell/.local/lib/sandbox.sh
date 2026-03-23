# Creates a temp directory and symlinks it to ~/sandbox. Useful for
# experimenting or other ephemeral files you don't want cluttering up
# other directories.

SANDBOXRC=$HOME/.sandboxrc
SANDBOX_LINK=$HOME/sandbox

if [[ -f "$SANDBOXRC" ]]; then
  SANDBOX_TEMP_DIR="$(cat "$SANDBOXRC")"
  export SANDBOX_TEMP_DIR
fi

if [[ ! -d "$SANDBOX_TEMP_DIR" ]]; then
  SANDBOX_TEMP_DIR="$(mktemp -d)"
  export SANDBOX_TEMP_DIR
  echo "$SANDBOX_TEMP_DIR" > "$SANDBOXRC"
  rm -f "$SANDBOX_LINK"
  ln -s "$SANDBOX_TEMP_DIR" "$SANDBOX_LINK"
fi
