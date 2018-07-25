# LOAD LOCAL BASHRC
[ -e $HOME/.bashrc.local ] && source $HOME/.bashrc.local

# XDG SETUP
[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z "$XDG_CACHE_HOME" ]] && export XDG_CACHE_HOME="$HOME/.cache"

# LOAD MAIN CONFIG
source $XDG_CONFIG_HOME/bash/config.sh

# LOAD START FILES
for file in $XDG_CONFIG_HOME/bash/autoload/*; do
  source "$file"
done
