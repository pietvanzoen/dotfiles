if is_executable brew && [[ -e "$(brew --prefix)/etc/profile.d/autojump.sh" ]]; then
  safe_source "$(brew --prefix)/etc/profile.d/autojump.sh"
else
  safe_source "$HOME/.autojump/etc/profile.d/autojump.sh"
fi
