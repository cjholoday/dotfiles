#!/bin/bash
#
# Purpose: Manage setup of dotfiles

# Check if the latest command failed
function check {
    if [ "$?" != "0" ]; then
        echo "failed check: $1"
        exit 1
    fi
}

cd "$HOME/dotfiles"
check "failed to find dotfiles directory" || exit 1

required_commands="curl git vim"
missing_required_command=0

set -f # disable globbing
for command in $required_commands; do
    if [ -z "$(command -v "$command")" ]; then
        echo "Missing required command '$command'" >&2
        missing_required_command=1
    fi
done
set +f # enable globbing
if [ "$missing_required_command" = 1 ]; then
    exit 1
fi

printf "\n\n*** Symlinking dotfiles...\n\n"
sh symlink.sh
check "'sh symlink.sh' failed!" || exit 1

printf "\n\n*** Upgrading vim with plugins...\n\n"
sh upgrade_vim.sh
check "'sh upgrade_vim.sh' failed!" || exit 1
