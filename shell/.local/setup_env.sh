LOCAL_DIR=$(dirname $0)
source "$LOCAL_DIR/helpers.sh"

safe_source $HOME/.env.sh.local
safe_source $HOME/.env.sh

for filename in $LOCAL_DIR/lib/*.sh; do
  safe_source $filename
done

if [[ -n "$IS_BASH" ]]; then
  safe_source $HOME/.env.bash.local
  safe_source $HOME/.env.bash
  for filename in $LOCAL_DIR/lib/*.bash; do
    safe_source $filename
  done
fi

if [[ -n "$IS_ZSH" ]]; then
  safe_source $HOME/.env.zsh.local
  safe_source $HOME/.env.zsh
  for filename in $LOCAL_DIR/lib/*.zsh; do
    safe_source $filename
  done
fi
