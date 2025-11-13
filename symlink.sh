#!/bin/sh

# Create a symlink. Will prompt the user if there is an existing file
# at the source path. Choosing to overwrite will back up the file
# into dotfiles/backups_from_setup
function create_symlink() {
    local symlink_source="$1"
    local symlink_dest="$2"

    if [ -f "$symlink_source" ]; then
        if [ "$(realpath "$symlink_source")" = "$(realpath "$symlink_dest")" ]; then

            echo "Already set up: $symlink_source -> $symlink_dest"
            return # Nothing to do. Already symlinked properly
        fi

        echo "Warning: file '$symlink_source' already exists. Overwrite it and backup existing file?"
        read -rp "Overwrite this symlink? [y/N]: " answer

        case "$answer" in
            [Yy]* )
                local timestamp="$(date +%Y-%m-%d-%H:%M:%S)"
                local backup_path="$HOME/dotfiles/backups_from_setup/$(basename "$symlink_source").$timestamp.backup" 
                echo "Backing up '$symlink_source' at '$backup_path'"
                mv "$symlink_source" "$backup_path"
                ;;
            * )
                echo "Not overwriting."
                return
                ;;
        esac
    fi

    echo "Symlinking: $symlink_source -> $symlink_dest"
    ln -s "$symlink_dest" "$symlink_source"
}

# Do a sanity check that the repo is placed in the correct directory
dotfiles_path="$HOME/dotfiles"
if [ ! -d "$dotfiles_path" ] || [ ! -f "$dotfiles_path/setup.sh" ]; then
    printf 'error: the dotfiles repository must be placed in $HOME\n'
    exit 1
fi

# Symlink all the dotfiles into $HOME
set -f # disable globbing
dotfiles="bash_profile bashrc vimrc cheatsheet gitconfig local_gitconfig local_bashrc gitignore inputrc"
for dotfile in $dotfiles; do
    create_symlink  "$HOME/.$dotfile" "$dotfiles_path/$dotfile"
done
set +f # re-enable globbing

if [ "$(uname)" = "Darwin" ]; then
    create_symlink "$HOME/Library/Application Support/Code/User/settings.json" "$dotfiles_path/vscode_settings.json"
fi
