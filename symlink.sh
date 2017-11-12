#!/bin/sh

# Usage: sh setup.sh [force]
#
# If any string is passed for the force argument, then files in $HOME will be overwritten
# with symlinks
force="$1"


try_symlink() {
    # While not strictly POSIX, 'local' really should be used here
    local force="$1"
    local dotfile_path="$2"
    local target="$3"

    if [ "$force" != "FORCE" ] && [ -f "$target" ]; then
        printf "warning: '$target' already exists. skipping it...\n"
    else
        ln -sf "$dotfile_path" "$target"
    fi
}

# create .user.gitconfig if it doesn't exist
touch local_gitconfig
touch local_bashrc

dotfiles="bash_profile bashrc vimrc cheatsheet gitconfig local_gitconfig local_bashrc gitignore inputrc"
dotfiles_path="$HOME/dotfiles"

# do a sanity check that the repo is placed in the correct directory
if [ ! -d "$dotfiles_path" ] || [ ! -f "$dotfiles_path/setup.sh" ]; then
    printf 'error: the dotfiles repository must be placed in $HOME\n'
    exit 1
fi

# symlink all the dotfiles into $HOME
set -f # disable globbing
for dotfile in $dotfiles; do
    try_symlink "$force" "$dotfiles_path/$dotfile" "$HOME/.$dotfile"
done
set +f # re-enable globbing

if [ "$(uname)" = "Darwin" ]; then
    try_symlink "$force" "$dotfiles_path/vscode_settings.json" \
        "$HOME/Library/Application Support/Code/User/settings.json"
fi
