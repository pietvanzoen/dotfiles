load_dirrc() {
  if [ "${PREV_DIR}" != "$(pwd -P)" ]; then
    if [ -r $HOME/.dirrc-global ]; then
      source $HOME/.dirrc-global
    fi
    if [ -r .dirrc ]; then
      source ./.dirrc
    fi
    PREV_DIR=$(pwd -P)
  fi
}

if [[ -n $ZSH_VERSION ]]; then
  precmd_functions+='load_dirrc'
else
  export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} load_dirrc"
fi
