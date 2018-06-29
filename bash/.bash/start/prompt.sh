#!/bin/bash

BASE_USER="piet"
BASE_HOST="finn"

__ps1_main() {
  local EXIT="$?"
  export PS1="$(__exit_caret $EXIT) $(__remote)$(__user_host) $(__cwd)$(__git_info)$(__job_info) "
}
export PROMPT_COMMAND="__ps1_main; ${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

__exit_caret() {
  local exit_code=$1
  if [ $EXIT != 0 ]; then
    echo -n "$__red>>$__reset_color"
  else
    echo -n "$__green>>$__reset_color"
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

__remote() {
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    echo -n "$__dark"
    echo -n "ssh "
    echo -n "$__reset_color"
  fi
}

__user_host() {
  local color=$__dark
  local ssh=""
  if [[ "$(whoami)" != "$BASE_USER" ]] || [[ "$(hostname)" != "$BASE_HOST" ]]; then
    color=$__blue
  fi
  echo -n "$color$ssh\u@\h$__reset_color"
}

source $HOME/.bash/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_STATESEPARATOR="|"
GIT_PS1_SHOWUPSTREAM="auto"
__git_info() {
  local info=$(__git_ps1 | sed -E 's/\(|\)//g' | xargs)
  [[ -z $info ]] && return;
  local branch="$(echo $info | cut -d '|' -f 1)"
  local status="$(echo $info | cut -d '|' -f 2)"

  echo -n "$__dark("
  echo -n "$__red$branch"
  echo -n "$__yellow$status"
  echo -n "$__dark)$__reset_color"
}

__job_info() {
  local count="$(jobs | grep -v autojump | wc -l)"
  [[ "$count" == "0" ]] && return
  echo -n " $__dark[$count]$__reset_color"
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
