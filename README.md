Piet van Zoen's Dotfiles
===

## Install

Clone the repository: `git clone https://github.com/pietvanzoen/dotfiles.git ~/`

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

From the cloned dotfiles directory run `./install`. Any `*.example` files will be initialized. Be sure to go through and update them with the relevant information.

## Uninstall

Run `./uninstall` from the cloned dotfiles directory to uninstall.

## Credits

Other dotfile repos that I've borrowed from or been inspired by:
* [Kraymer/F-dotfiles](https://github.com/Kraymer/F-dotfiles)
* [garybernhardt/dotfiles](https://github.com/garybernhardt/dotfiles)
