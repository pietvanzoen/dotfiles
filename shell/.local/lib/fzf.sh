is_zsh && safe_source ~/.fzf.zsh
is_bash && safe_source ~/.fzf.bash

# Setting fd as the default source for fzf
if is_executable fd; then
  export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --color=always'
else
  export FZF_DEFAULT_COMMAND="find . -type f -not -path '**/.git/**'"
fi

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --reverse --ansi'
