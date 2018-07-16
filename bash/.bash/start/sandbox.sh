
SANDBOXRC=$HOME/.sandboxrc

if [[ -f "$SANDBOXRC" ]]; then
  export SANDBOX_PATH="$(cat $SANDBOXRC)"
fi

if [[ ! -d "$SANDBOX_PATH" ]]; then
  export SANDBOX_PATH="$(mktemp -d)"
  echo $SANDBOX_PATH > $SANDBOXRC
fi


sandbox() {
  local name=$1
  mkdir -p "$SANDBOX_PATH/$name"
  cd "$SANDBOX_PATH/$name"
}
