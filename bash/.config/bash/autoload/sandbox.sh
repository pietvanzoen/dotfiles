
SANDBOXRC=$HOME/.sandboxrc
SANDBOX_LINK=$HOME/sandbox

if [[ -f "$SANDBOXRC" ]]; then
  export SANDBOX_TEMP_DIR="$(cat $SANDBOXRC)"
fi

if [[ ! -d "$SANDBOX_TEMP_DIR" ]]; then
  export SANDBOX_TEMP_DIR="$(mktemp -d)"
  echo $SANDBOX_TEMP_DIR > $SANDBOXRC
  rm -f $SANDBOX_LINK
  ln -s $SANDBOX_TEMP_DIR $SANDBOX_LINK
fi


sandbox() {
  local name=$1
  mkdir -p "$SANDBOX_LINK/$name"
  cd "$SANDBOX_LINK/$name"
}
