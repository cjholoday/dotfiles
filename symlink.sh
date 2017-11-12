#!/bin/sh

# Usage: sh setup.sh [force] [machine_id]
#
# [machine_id] will be written to a file named machine_id in the dotfiles directory. It
# is used to identify which machine this installation is for. This is useful for 
# determining which PS1 to use, for example
#
# If any string is passed for the force argument, then files in $HOME will be overwritten
# with symlinks
force="$1"
machine_id="$2"


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

if [ ! -z "$machine_id" ]; then
    echo "$machine_id" > "$dotfiles_path"/machine_id
fi

# symlink all the dotfiles into $HOME
set -f # disable globbing
for dotfile in $dotfiles; do
    try_symlink "$force" "$dotfiles_path/$dotfile" "$HOME/.$dotfile"
done
set +f # re-enable globbing

if [ "$(uname)" == "Darwin" ]; then
    try_symlink "$force" "$dotfiles_path/vscode_settings.json" \
        "$HOME/Library/Application Support/Code/User/settings.json"
fi
