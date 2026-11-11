eval "$(fnm env --use-on-cd)"
# Node 25+ no longer bundles corepack; install it once per Node version.
command -v corepack >/dev/null || npm install -g corepack >/dev/null 2>&1
corepack enable
