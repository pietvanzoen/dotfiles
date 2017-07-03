#!/bin/zsh

PROMPT='$(__ret_status)$(__working_dir)$(__git_info)$(__job_count)$(__nvm_status)$(__exec_time) ♯ '

###############################################
# UTILITY COMMANDS
###############################################
function resetprompt() {
  unset HIDE_TIME
  unset FAST_PROMPT
}

# Turn off slower prompt features like git and nvm
function fastprompt() {
  export FAST_PROMPT=true
}

# Turn off command timer
function hidetime() {
  export HIDE_TIME=true
}


###############################################
# ZSH THEME CONFIG
###############################################
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[black]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}*%{$fg[black]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[black]%})"


###############################################
# PROMPT FUNCTIONS
###############################################
# Show red/green indicator based on last command's exit status
function __ret_status() {
  echo -n "%(?:%{$fg[green]%}❖:%{$fg[red]%}❖)"
}

function __working_dir() {
  echo -n " %{$fg[cyan]%}%c%{$reset_color%}"
}

# Git branch info
function __git_info() {
  [[ ! -z $FAST_PROMPT ]] && return;
  git_prompt_info
}

# When there's an .nvmrc show current nvm version
function __nvm_status() {
  [[ ! -z $FAST_PROMPT ]] && return;

  $(type nvm >/dev/null 2>&1) || return

  [[ -f ./.nvmrc ]] || return;

  local nvm_status=$(nvm current 2>/dev/null)

  echo -n " %{$fg[black]%}"
  echo -n "⬢ ${nvm_status}"
  echo -n "%{$reset_color%}"
}

# Number of background jobs
function __job_count() {
  local n=$(jobs | grep 'suspended' | wc -l | xargs)
  [[ $n -gt 0 ]] && echo -n " %{$fg[black]%}[${n}]%{$reset_color%}"
}

# EXECUTION TIME
function __exec_time() {
  [[ ! -z $HIDE_TIME ]] && return;
  echo -n " %{$fg[black]%}"
  echo -n "$(__displaytime $EXEC_TIME_duration)"
  echo -n "%{$reset_color%}"
}


###############################################
# EXEC TIME HOOK COMMANDS
###############################################
# Execution time start
function __exec_time_preexec_hook() {
  EXEC_TIME_start=$(__get_time)
}

# Execution time end
function __exec_time_precmd_hook() {
  [[ -n $EXEC_TIME_duration ]] && unset EXEC_TIME_duration
  [[ -z $EXEC_TIME_start ]] && return
  local SPACESHIP_EXEC_TIME_stop=$(__get_time)
  EXEC_TIME_duration=$(( $SPACESHIP_EXEC_TIME_stop - $EXEC_TIME_start ))
  unset EXEC_TIME_start
}

# setup hooks for exec time
add-zsh-hook preexec __exec_time_preexec_hook
add-zsh-hook precmd __exec_time_precmd_hook


###############################################
# UTILITY FUNCTIONS
###############################################
# Display seconds in human readable fromat
# Based on http://stackoverflow.com/a/32164707/3859566
# USAGE:
#   __displaytime <seconds>
function __displaytime() {
  local T=$1
  local D=$((T/1000/60/60/24))
  local H=$((T/1000/60/60%24))
  local M=$((T/1000/60%60))
  local S=$((T/1000%60))
  local MS=$((T%1000))
  [[ $D > 0 ]] && printf '%dd•' $D
  [[ $H > 0 ]] && printf '%dh•' $H
  [[ $M > 0 ]] && printf '%dm•' $M
  [[ $S > 0 ]] && printf '%ds•' $S
  printf '%dms' $MS
}

# Get current ms time
# requires brew install coreutils for gdate
function __get_time() {
  echo -n $(($(gdate +%s%N)/1000000))
}
