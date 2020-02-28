export IS_BASH=true
export IS_ZSH=

source $HOME/.local/setup_env.sh

# HISTORY
export HISTSIZE=32768;
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups;
export HISTIGNORE="cd:cd -:pwd:exit:date";

# BASH COMPLETION
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi
