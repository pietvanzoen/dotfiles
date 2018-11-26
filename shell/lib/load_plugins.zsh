if [[ ! -f ~/.zplug/init.zsh ]]; then
  echo "Zplug not installed. Skipping plugin loading."
  return
fi

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"

if ! zplug check --verbose; then
    echo -n "==> Install? [y/n] "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
