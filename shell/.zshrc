# FIX PATH
# ZSH messes up PATH order after zshenv has loaded
PATH="$MY_PATH"

# MAIN CONFIG
source $HOME/.config/zsh/plugins.zsh
source $HOME/.config/zsh/config.zsh
source $HOME/.config/shared/env.sh
source $HOME/lib/aliases.zsh

# # LOAD START FILES
for file in $HOME/.config/zsh/autoload/* $HOME/.config/shared/autoload/*; do
  source "$file"
done
