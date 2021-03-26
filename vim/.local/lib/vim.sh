alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"
alias vim=nvim
vm() {
  if [ -e ./Session.vim ]; then
    nvim -S
  else
    nvim -c 'Obsession' .
  fi
}
