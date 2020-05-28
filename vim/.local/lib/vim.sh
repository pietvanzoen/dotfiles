alias clean-swp="find . -regex '.*\.sw[p|o]$' | xargs rm -v"
vm() {
  if [ -e ./Session.vim ]; then
    vim -S
  else
    vim .
  fi
}
