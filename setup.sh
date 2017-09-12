#!bin/sh

# Usage: sh setup.sh [machine_id] [force?]
#
# [machine_id] will be written to a file named machine_id in the dotfiles directory. It
# is used to identify which machine this installation is for. This is useful for 
# determining which PS1 to use, for example
#
# If any string is passed for the force argument, then files in $HOME will be overwritten
# with symlinks
machine_id="$1"
force="$2"

dotfiles=".bash_profile .bashrc .vimrc"
dotfiles_path="$HOME/dotfiles"

# do a sanity check that the repo is placed in the correct directory
if [ ! -d "$dotfiles_path" ] || [ ! -f "$dotfiles_path/setup.sh" ]; then
    printf 'error: the dotfiles repository must be placed in $HOME\n'
    exit 1
fi

echo "$machine_id" > "$dotfiles_path"/machine_id

# symlink all the dotfiles into $HOME
set -f # disable globbing
for dotfile in $dotfiles; do
    if [ -z "$force" ] && [ ! -f "$HOME/$dotfile" ]; then
        printf "warning: '$HOME/$dotfile' already exists. skipping it...\n"
    else
        ln -sf "$dotfiles_path/$dotfile" "$HOME/$dotfile"
    fi
done
set +f # re-enable globbing
