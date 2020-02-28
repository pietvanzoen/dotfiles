
# GNUPG
is_executable gpg-agent && [[ -z "$(pgrep gpg-agent)" ]] && eval $(gpg-agent --daemon)
