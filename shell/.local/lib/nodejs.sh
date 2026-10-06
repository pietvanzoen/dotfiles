
alias show-scripts="jq .scripts package.json"
alias fubar="rm -rIf node_modules && yarn"

alias nr="npm run"
alias ni="npm install"

export HUSKY=1
export CUTR_AUTO_LINT=1
if command -v mkcert >/dev/null 2>&1; then
  mkcert_root="$(mkcert -CAROOT)"
  if [ -f "${mkcert_root}/rootCA.pem" ]; then
    export NODE_EXTRA_CA_CERTS="${mkcert_root}/rootCA.pem"
  fi
fi
