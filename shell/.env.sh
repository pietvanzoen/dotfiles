# Fix locale
export LC_ALL=en_US.UTF-8

# Timezone
export TZ=America/Los_Angeles

# EDITOR
if [[ -e $(which nvim) ]]; then
  EDITOR=$(which nvim)
export EDITOR
else
  EDITOR=$(which vim)
export EDITOR
fi

# COLORS
export TERM=xterm-256color

# BIN
export PATH=$HOME/.local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

export PLAYDATE_SDK_PATH="$HOME/Developer/PlaydateSDK"
