Piet van Zoen's Dotfiles
===

## Install

### Setup repo

1. Clone the repository: `git clone https://github.com/pietvanzoen/dotfiles.git ~/`
1. Install submodules: `git submodule update --depth=1 --recursive`

### Homebrew

```bash
cd ~/dotfiles/_homebrew
brew tap homebrew/bundle
brew bundle
```

### [Oh my zsh](https://github.com/robbyrussell/oh-my-zsh)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

### Dotfiles

1. Setup `stow`: `stow -t ~ stow`
1. Install desired package via `stow <directory>`

## Credits

Other dotfile repos that I've borrowed from or been inspired by:
* [Kraymer/F-dotfiles](https://github.com/Kraymer/F-dotfiles)
* [garybernhardt/dotfiles](https://github.com/garybernhardt/dotfiles)

## TODO
- [x] Brewfile
- [ ] install OMZ via submodule
