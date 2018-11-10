export IS_BASH=true
export IS_ZSH=

# LOAD MAIN CONFIG
source $HOME/.config/shared/env.sh
source $HOME/.config/bash/config.sh

# LOAD START FILES
for file in $HOME/.config/bash/autoload/* $HOME/.config/shared/autoload/*; do
  source "$file"
done
