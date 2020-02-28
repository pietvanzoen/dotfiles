# HOMEBREW PATHS
libexec_packages=(coreutils gnu-indent gnu-tar grep gnu-sed gawk gnu-time findutils)
for pkg in ${libexec_packages[*]}; do
  add_path "/usr/local/opt/$pkg/libexec/gnubin"
  add_manpath "/usr/local/opt/$pkg/libexec/gnuman"
done

bin_packages=(openssl curl gnu-getopt)
for pkg in ${bin_packages[*]}; do
  add_path "/usr/local/opt/$pkg/bin"
  add_path "/usr/local/opt/$pkg/share/man"
done

export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/

# OPTIONS
export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"
export HOMEBREW_NO_ANALYTICS=1 # disable homebrew analytics

# GNU LS colors
is_executable dircolors && eval "$(dircolors $HOME/.dir_colors)"
