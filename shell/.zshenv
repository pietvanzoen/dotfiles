export IS_ZSH=true
fpath=( $fpath "$HOME/.zfunctions" )

# Make node/npm/zx available in all shells (non-interactive, launchd, cron, etc.)
export PATH="$HOME/Library/Application Support/fnm/aliases/default/bin:$PATH"
