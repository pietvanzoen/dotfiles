#!/bin/zsh

nvm_status() {
  $(type nvm >/dev/null 2>&1) || return

  [[ -f ./.nvmrc ]] || return;

  local nvm_status=$(nvm current 2>/dev/null)

  echo -n "%{$fg[black]%}"
  echo -n "⬢ ${nvm_status}"
  echo -n "%{$reset_color%} "
}

local ret_status="%(?:%{$fg[green]%}❖:%{$fg[red]%}❖)"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%}$(git_prompt_info) $(nvm_status)♯ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[black]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}*%{$fg[black]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[black]%})"
