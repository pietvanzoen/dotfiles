

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
    --region eu-central-1 \
    --query "Reservations[].Instances[].[Tags[?Key=='Name']|[0].Value, PrivateIpAddress]" \
    --output text | grep "$1"
  }

function cutr-postgres-staging() {
  echo "==> Serving STAGING postgres on port 5433"
	ssh -N -L 5433:postgres-staging-db.cl2pnakypheb.eu-central-1.rds.amazonaws.com:5432 ec2-user@bastion-staging
}
function cutr-postgres-prod() {
  echo "==> Serving PRODUCTION postgres on port 5434"
	ssh -N -L 5434:postgres-prod-db.cl2pnakypheb.eu-central-1.rds.amazonaws.com:5432 ec2-user@bastion-prod
}
