# LOAD LOCAL BASHRC
[ -e $HOME/.bashrc.local ] && source $HOME/.bashrc.local

# LOAD MAIN CONFIG
source $HOME/.bash/config.sh

# LOAD START FILES
for file in $HOME/.bash/start/*; do
  source "$file"
done
