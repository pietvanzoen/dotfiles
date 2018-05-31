alias grt=". git-root"

# GIT-GET
export PROJ="$HOME/repos/"
export GIT_PATH="$PROJ"

# HUB
[ -e "$(which hub)" ] && eval "$(hub alias -s)"
