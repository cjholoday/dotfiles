#!/bin/sh

# Usage: sh setup.sh [FORCE/STASH]
#
# If no argument is passed, existing dotfiles will not be overwritten
#
# If FORCE is passed, existing dotfiles will be overwritten
#
# If STASH is passed, existing dotfiles are saved as .old_*-TIMESTAMP
# where * is the name of the old dotfile, and TIMESTAMP is the current time

# What to do when encountering an existing dotfile
collision_scheme="$1"

TIMESTAMP="$(date +%Y-%m-%d-%H:%M:%S)"


try_symlink() {
    # While not strictly POSIX, 'local' really should be used here
    local collision_scheme="$1"
    local dotfile_path="$2"
    local target="$3"

    if [ -f "$target" ]; then
        if [ "$collision_scheme" = "FORCE" ] && [ -f "$target" ]; then
            echo "FORCE"
            ln -sf "$dotfile_path" "$target"
        elif [ "$collision_scheme" = "STASH" ]; then
            old_version="$(dirname "$target")/.old$(basename "$target")-$TIMESTAMP" 
            mv "$target" "$old_version"
            echo "warning: symlink collision with '$target'"
            echo "Stashing old version at '$old_version'"
            echo ""
            ln -s "$dotfile_path" "$target"
        else
            printf "warning: '$target' already exists. skipping it...\n"
        fi
    else
        ln -s "$dotfile_path" "$target"
    fi
            
}


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
    try_symlink "$collision_scheme" "$dotfiles_path/$dotfile" "$HOME/.$dotfile"
done
set +f # re-enable globbing

if [ "$(uname)" = "Darwin" ]; then
    try_symlink "$collision_scheme" "$dotfiles_path/vscode_settings.json" \
        "$HOME/Library/Application Support/Code/User/settings.json"
fi
