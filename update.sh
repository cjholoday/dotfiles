#!/bin/bash
#
# Update the dotfiles to reflect any new changes

check() {
    if [ "$?" != "0" ]; then
        echo "failed check: $1"
        exit 1
    fi
}

cd "$HOME/dotfiles"
check "failed to find dotfiles directory" || exit 1

printf "\n\n*** Obtaining new changes...\n\n"
git pull origin master
check "failed to pull from repository" || exit 1

printf "\n\n*** Symlinking dotfiles...\n\n"
sh symlink.sh
check "'sh symlink.sh' failed!" || exit 1

printf "\n\n*** Upgrading vim with plugins...\n\n"
sh upgrade_vim.sh
check "'sh upgrade_vim.sh' failed!" || exit 1
