# Fix locale
export LC_ALL=en_US.UTF-8

# EDITOR
if [[ -e $(which nvim) ]]; then
  export EDITOR=$(which nvim)
else
  export EDITOR=$(which vim)
fi

# COLORS
export TERM=xterm-256color

# BIN
export PATH=$HOME/.local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
