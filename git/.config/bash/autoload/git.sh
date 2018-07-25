alias grt=". git-root"

# GIT-GET
export PROJ="$HOME/repos/"
export GIT_PATH="$PROJ"

# HUB
is_executable hub && eval "$(hub alias -s)"
