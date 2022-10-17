# HOMEBREW PATHS
export BREW_PREFIX="$(brew --prefix)"

libexec_packages=(coreutils gnu-indent gnu-tar grep gnu-sed gawk gnu-time findutils)
for pkg in ${libexec_packages[*]}; do
  add_path "$BREW_PREFIX/opt/$pkg/libexec/gnubin"
  add_manpath "$BREW_PREFIX/opt/$pkg/libexec/gnuman"
done

bin_packages=(openssl curl gnu-getopt gnu-sed)
for pkg in ${bin_packages[*]}; do
  add_path "$BREW_PREFIX/opt/$pkg/bin"
  add_path "$BREW_PREFIX/opt/$pkg/share/man"
done

export LIBRARY_PATH="$LIBRARY_PATH:$BREW_PREFIX/opt/openssl/lib/"

# OPTIONS
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"
export HOMEBREW_NO_ANALYTICS=1 # disable homebrew analytics

# GNU LS colors
is_executable dircolors && eval "$(dircolors $HOME/.dir_colors)"
