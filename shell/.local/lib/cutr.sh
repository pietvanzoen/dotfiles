

alias cutr-login-staging="aws sso login --profile cutr-staging"

function cutr-login () {
PASS="$(secrets get cutr-aws-ssh-passphrase)"
  expect << EOF
            spawn ssh-add  -t 4h $HOME/.ssh/aws-ssh-access
            expect "Enter passphrase"
            send  "${PASS/$/\\$}\r"
            expect eof
EOF
}


function cutr-shn() {
  aws ec2 describe-instances \
    --profile cutr \
    --region eu-central-1 \
    --query "Reservations[].Instances[].[Tags[?Key=='Name']|[0].Value, PrivateIpAddress]" \
    --output text | grep "$1"
  }

function cutr-shn-staging() {
  aws ec2 describe-instances \
    --profile cutr-staging \
    --region eu-central-1 \
    --query "Reservations[].Instances[].[Tags[?Key=='Name']|[0].Value, PrivateIpAddress]" \
    --output text | grep "$1"
  }

function get_db_host() {
  CUTR_ENV=${1}

  if [[ "${CUTR_ENV}" == "cutr-staging" ]]; then
    aws rds describe-db-instances --profile ${CUTR_ENV} \
      --region eu-central-1 \
      --query 'DBInstances[].Endpoint[].Address[]' \
      --output text | grep "$1"
  else
    echo "Only staging supported at this time"
  fi
}

function get_ssh_instance() {
  aws ec2 describe-instances \
    --profile ${1} \
    --region eu-central-1 \
    --filters 'Name=tag:Name,Values=ssh_proxy' \
    --query "Reservations[].Instances[].[Tags[?Key=='Name']|[0].Value, InstanceId]" \
    --output text | awk {'print $2'}
}

get_profile() {
  if [[ "$1" == "staging" ]]; then
    echo cutr-staging
  elif [[ "$1" == "prod" ]]; then
    echo cutr
  fi
}

function send_key() {
  INSTANCE_ID=${1}
  CUTR_ENV=${2}
  aws ec2-instance-connect send-ssh-public-key \
    --profile ${CUTR_ENV} \
    --instance-id ${INSTANCE_ID} \
    --instance-os-user ubuntu \
    --ssh-public-key file:///Users/piet/.ssh/id_rsa.pub
}

function cutr-postgres-staging() {
  CUTR_ENV="$(get_profile 'staging')"
  DB_HOST="$(get_db_host "${CUTR_ENV}")"
  INSTANCE_ID=$(get_ssh_instance "${CUTR_ENV}")
  send_key "${INSTANCE_ID}" "${CUTR_ENV}"
  echo "==> Serving STAGING postgres on port 5433"
	ssh -N -L 5433:${DB_HOST}:5432 ubuntu@3.74.186.186
}

function cutr-postgres-prod() {
  DB_HOST=$(get_db_host prod)
  echo "==> Serving PRODUCTION postgres on port 5434"
	ssh -N -L 5434:postgres-prod-db.cl2pnakypheb.eu-central-1.rds.amazonaws.com:5432 ec2-user@bastion-prod
}
