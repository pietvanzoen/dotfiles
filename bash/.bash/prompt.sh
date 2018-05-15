#/bin/bash

__ps1_main() {
  local EXIT="$?"
  export PS1="$(__exit_caret $EXIT) $(__user_host) $(__cwd)$(__git_info)$(__job_info) "
}
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} __ps1_main; history -a;"

__exit_caret() {
  local exit_code=$1
  if [ $EXIT != 0 ]; then
    echo -n "$__red\\]❖$__reset_color"
  else
    echo -n "$__green\\]❖$__reset_color"
  fi
}

__cwd() {
  echo -n "$__cyan$(basename "$PWD")$__reset_color"
}

__user_host() {
  echo -n "$__dark\u@\h$__reset_color"
}

source $HOME/.shell/git-prompt.sh
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
export __dark="\[\e[2;36m\]"
export __red="\[\e[0;31m\]"
export __green="\[\e[0;32m\]"
export __yellow="\[\e[0;33m\]"
export __blue="\[\e[0;34m\]"
export __purple="\[\e[0;35m\]"
export __cyan="\[\e[0;36m\]"
export __reset_color="\[\e[m\]"
