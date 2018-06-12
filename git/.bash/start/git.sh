alias grt=". git-root"

# GIT-GET
export PROJ="$HOME/repos/"
export GIT_PATH="$PROJ"

# HUB
[ -e "$(which hub > /dev/null 2>&1)" ] && eval "$(hub alias -s)"
