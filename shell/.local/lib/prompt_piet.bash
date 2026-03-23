#!/bin/bash

# shellcheck disable=SC2034
BASE_USER="piet"
# shellcheck disable=SC2034
BASE_HOST="finn"
CONNECTION_TYPE=""
if pstree -ps $$ | grep -q mosh-server; then
  CONNECTION_TYPE="mosh"
elif [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
  CONNECTION_TYPE="ssh"
fi


__ps1_main() {
  local EXIT="$?"
  local ps1_val
  ps1_val="$(__exit_caret "$EXIT") $(__context) $(__cwd)$(__git_info)$(__node)$(__job_info) "
  export PS1="$ps1_val"
}
if [[ "$PROMPT_COMMAND" != *'__ps1_main'* ]]; then
  export PROMPT_COMMAND="__ps1_main; ${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"
fi

__exit_caret() {
  [[ -z "$TMUX" ]] && [[ -n "$ITERM_PROFILE" ]] && return
  local exit_code=$1
  # shellcheck disable=SC2034
  local _unused="$exit_code"
  if [ "$EXIT" != 0 ]; then
    echo -n "${__red}λ$__reset_color"
  else
    echo -n "${__green}λ$__reset_color"
  fi
}

__cwd() {
  local dir=""
  if [[ "$(pwd)" == "$HOME" ]]; then
    dir="~"
  else
    dir="$(basename "$PWD")"
  fi
  echo -n "$__cyan$dir$__reset_color"
}

__context() {
  echo -n "$(__connection)$(__host)$(__screen)"
}

__connection() {
  local connection=""
  if [[ -n "$CONNECTION_TYPE" ]]; then
    connection="$__blue$CONNECTION_TYPE$__reset_color$__dark|$__reset_color"
  fi
  echo -n "$connection"
}

__host() {
  echo -n "$__dark\u@\h$__reset_color"
}

__screen() {
  if [[ -z "$STY" ]]; then
    return
  fi
  echo -n "$__dark|$STY$__reset_color"
}

__node() {
  [[ ! -d "$(git-root)/node_modules" ]] && return
  echo -n " ${__dark}⬢ $(node -v)$__reset_color"
}

# shellcheck source=/dev/null
source "$HOME/lib/git-prompt.sh"
# shellcheck disable=SC2034
GIT_PS1_SHOWDIRTYSTATE=1
# shellcheck disable=SC2034
GIT_PS1_SHOWUNTRACKEDFILES=1
# shellcheck disable=SC2034
GIT_PS1_STATESEPARATOR="|"
# shellcheck disable=SC2034
GIT_PS1_SHOWUPSTREAM="auto"
__git_info() {
  local info
  info=$(__git_ps1 | sed -E 's/\(|\)//g' | xargs)
  [[ -z $info ]] && return;
  local branch
  local status
  branch="$(echo "$info" | cut -d '|' -f 1)"
  status="$(echo "$info" | cut -d '|' -f 2,3)"

  echo -n "$__dark("
  echo -n "$__red$(truncate-string 30 "$branch")"
  echo -n "$__yellow$status"
  echo -n "$__dark)$__reset_color"
}

__job_info() {
  local count
  count="$(jobs | grep -c -v autojump || true)"
  [[ "$count" == "0" ]] && return
  echo -n " ${__dark}[$count]${__reset_color}"
}

export __black="\[\e[0;30m\]"
export __dark="\[\e[1;32m\]"
export __red="\[\e[0;31m\]"
export __green="\[\e[0;32m\]"
export __yellow="\[\e[0;33m\]"
export __blue="\[\e[0;34m\]"
export __purple="\[\e[0;35m\]"
export __cyan="\[\e[0;36m\]"
export __reset_color="\[\e[m\]"
