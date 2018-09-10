
export TASKFLOW_DIR="$HOME/repos/bitbucket.wolterskluwer.io/scm/taskflow/wkapp-taskflow"

taskflow-update() {
  cd "$TASKFLOW_DIR"
  git checkout master
  yarn
  yarn build
}

alias taskflow-start="cd $TASKFLOW_DIR && yarn start:dev"
