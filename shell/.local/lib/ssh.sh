if [ ! -e $HOME/.1password ]; then
  mkdir -p ~/.1password && ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
fi

export SSH_AUTH_SOCK=~/.1password/agent.sock
