# a set of helper functions for bash scripts

_confirm() {
  echo -en "$__purple==> $__color_off$1 [y/n] "
  read answer
  if [ "$answer" == 'y' ]; then
    return 0
  else
    return 1
  fi
}

_header() {
  echo -e "$__cyan==> $__white$1$__color_off"
}

_info() {
  echo -e "$__cyan==> $__color_off$1"
}

_error() {
  echo -e "${__red}Error: $__color_off$1"
}

_warn() {
  echo -e "$__yellow==> $__color_off$1"
}

__color_off='\033[0m'       # Text Reset
__black='\033[0;30m'        # Black
__red='\033[0;31m'          # Red
__green='\033[0;32m'        # Green
__yellow='\033[0;33m'       # Yellow
__blue='\033[0;34m'         # Blue
__purple='\033[0;35m'       # Purple
__cyan='\033[0;36m'         # Cyan
__white='\033[0;37m'        # White
