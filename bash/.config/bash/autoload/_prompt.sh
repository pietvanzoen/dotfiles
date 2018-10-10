#!/bin/bash

BASE_USER="piet"
BASE_HOST="finn"
CONNECTION_TYPE=""
if [[ -n "$(pstree -ps $$ | grep mosh-server)" ]]; then
  CONNECTION_TYPE="mosh"
elif [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
  CONNECTION_TYPE="ssh"
fi


__ps1_main() {
  local EXIT="$?"
  export PS1="$(__exit_caret $EXIT) $(__context) $(__cwd)$(__git_info)$(__job_info) "
}
if [[ "$PROMPT_COMMAND" != *'__ps1_main'* ]]; then
  export PROMPT_COMMAND="__ps1_main; ${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"
fi

__exit_caret() {
  [[ -z "$TMUX" ]] && [[ -n "$ITERM_PROFILE" ]] && return
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

source $XDG_CONFIG_HOME/bash/git-prompt.sh
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
