# Dotfiles

## Setup

Before installing, make sure you have the following programs:
```
curl
git
vim
```

Run the following to install the dotfiles. You should be prompted for your name and email to set up your git credentials. Warning: ```setup.sh``` assumes you've cloned into ```~/dotfiles```
```
cd "$HOME"
git clone https://github.com/cjholoday/dotfiles.git
cd dotfiles
./setup.sh
. ~/.bashrc
```

You may have seen lines similar to the following while running ```setup.sh```:

```
warning: symlink collision with '/Users/colton/.bashrc'
Stashing old version at '/Users/colton/.old.bashrc-2017-11-12-22:03:36'
```

This means you had existing dotfiles installed in ```$HOME``` before running ```setup.sh```. If you want personalized .bashrc settings in addition to the .bashrc from this repository, place the changes in ```~/dotfiles/local_bashrc```. Putting them there will allow for easier updating (see below).

## Updating

Run either command below to update to the latest version:

```
# Bash users only. Works from any directory!
dotdate 

# Works even without bash
sh ~/dotfiles/update.sh
. ~/.bashrc
```

These work by pulling from this repository, then re-running ```symlink.sh``` and ```upgrade_vim.sh```. If you have any uncommited changes on one these dotfiles, pulling will fail. For that reason, using ```~/dotfiles/local_bashrc``` and ```~/dotfiles/local_gitconfig``` to store per-computer changes is ideal.
