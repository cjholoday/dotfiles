#!/bin/sh
#
# Purpose: Manage setup of dotfiles

cd "$HOME/dotfiles"

printf "Symlinking dotfiles...\n"
sh symlink.sh
if [ "$?" != 0 ]; then
    echo "Setting up symlinks failed"
    exit 1
fi
echo

printf "Setting up git profile...\n"
if [ -f derived/gitconfig_profile ]; then
    printf "Already set up: $(realpath derived/gitconfig_profile)\n"
else
    printf "Enter your full name: "
    read fullname
    printf "[user]\n    name = $fullname\n" > derived/gitconfig_profile
fi
