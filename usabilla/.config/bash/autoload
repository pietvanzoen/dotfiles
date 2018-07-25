
[ -e "$HOME/.usabillarc" ] && source $HOME/.usabillarc

function start-themes-api() {
  (screen -D -m -SR mongo mongod && \
  cd ~/Projects/usabilla/themes-api && screen -D -m -SR api yarn start:watch && /
  cd ~/Projects/usabilla/themes-publisher && screen -D -m -SR pub yarn start:watch && /
  echo 'themes api started')
}
