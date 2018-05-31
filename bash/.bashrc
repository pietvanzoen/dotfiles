# LOAD LOCAL BASHRC
[ -e $HOME/.bashrc.local ] && source $HOME/.bashrc.local

# LOAD START FILES
for file in $HOME/.bash/start/*.sh; do
  source "$file"
done
