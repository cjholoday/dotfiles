# Dotfiles

## Setup

Run the following to install the dotfiles.  Warning: `setup.sh` assumes you've cloned into `$HOME/dotfiles`
```
cd "$HOME"
git clone https://github.com/cjholoday/dotfiles.git
cd dotfiles
./setup.sh
. ~/.bashrc
```

Other bashrc additions can be placed at `$HOME/private_dotfiles/bashrc`, and they will be automatically picked up. This is useful for company-specific dotfile configuration.