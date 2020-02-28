[ -e $HOME/.ssh/id_rsa ] && export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
is_executable ssh-agent && [[ -z "$(pgrep ssh-agent)" ]] && eval "$(ssh-agent)" >/dev/null
