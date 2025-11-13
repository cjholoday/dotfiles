#!/bin/bash 

###########################################################
# aliases
###########################################################

alias rp='realpath'

# A better ls -l customized to my liking
lso() {
    # Options:
    #   -l: Use long listing format
    #   -t: Sort by time, newest first
    #   -r: Reverse sorting order (in this case, making newest last)
    #   -h: Print sizes in a human readable format e.g. 1K, 234M, 2G, etc.
    #
    # The awk command prepends yellow colored octal permissions (e.g. 755) before each line. It's taken from
    # https://askubuntu.com/questions/152001/how-can-i-get-octal-file-permissions-from-command-line and the only
    # modification is making the permissions colored yellow, which is done in the printf command
    ls -ltrh --color=always "$@" | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf("\033[1;33m%0o \033[0m",k);print}';
}

# print out disk usage for everything in cwd and sort the results
# SORT=sort
# if [ "$(uname)" = Darwin ]; then 
#     SORT=gsort
# fi
# alias dus='du -sh * | tee | "$SORT" -h'

dus() {
    # Temporary file to hold the unsorted results
    local tmpfile=$(mktemp)

    # Ensure temporary file is removed on script exit
    trap 'rm -f "$tmpfile"' EXIT

    # Determine the correct sort command (normal sort or gsort on macOS if installed)
    local SORT=sort
    if [ "$(uname)" = Darwin ]; then
        SORT=gsort
    fi

    # Print unsorted output as it comes in, and save it to the temporary file
    echo -e "Unsorted file and directory sizes:\n"
    for item in *; do
        du -sh "$item" | tee -a "$tmpfile"
    done

    # Sort the results stored in the temporary file and print
    echo
    echo
    echo
    echo
    echo --------------------------------------
    echo
    echo
    echo
    echo
    echo "Sorted file and directory sizes:"
    "$SORT" -h "$tmpfile"
}

alias l="lso"
alias m="make"
alias p="python"
alias g="git"
alias p3="python3"
alias grep="grep --color"
alias egrep="egrep --color"
alias fgrep="fgrep --color"
alias cheat="vim ~/.cheatsheet"
alias lcheat="vim ~/local_dotfiles/cheatsheet"


# Sourcing/Exporting
alias e='export'
alias srce='. "$(git_root)"/env/bin/activate'
alias srcb=". ~/.bashrc"

alias echopath='echo $PATH'

# Add a path to PATH
pathadd() {
    path_to_add="$1"

    # Ensure path is absolute
    path_to_add="$(realpath "$path_to_add")"

    if [ ! -d "$path_to_add" ]; then
        echo "Path does not point at directory: '$path_to_add'"
        echo
        echo "Usage: pathadd <directory-path-to-add>"
        echo "Note that you want to add a directory, not a file"

        return
    fi

    export PATH="${path_to_add}:$PATH"

    # Highlight the new path in PATH
    echo "$PATH" | grep "$path_to_add"
}

# Editing dotfiles
alias erc='vim ~/dotfiles/bashrc'
alias elrc='vim ~/local_dotfiles/bashrc'
alias ebashrc='vim ~/dotfiles/bashrc'
alias elbashrc='vim ~/local_dotfiles/bashrc'
alias ebashprofile='vim ~/dotfiles/bashrc'
alias evimrc='vim ~/dotfiles/vimrc'
alias egitignore='vim ~/dotfiles/gitignore'
alias egitconfig='vim ~/dotfiles/gitconfig'
alias einputrc='vim ~/dotfiles/inputrc'
alias evscodesettings='vim ~/dotfiles/vscode_settings.json'
alias elocalbashrc='vim ~/local_dotfiles/bashrc'


# Skip past intermediate directories where there is only one directory and nothing else
# Can be used with '..' to go up or a dirname to go down
cdzoom() {
    if [[ "$1" == ".." ]]; then
        prev_dir="$(pwd)"
        cd .. || return

        while true; do
            # Check for files (not hidden)
            file_count=$(find . -mindepth 1 -maxdepth 1 -type f ! -name '.*' | wc -l)
            if [[ $file_count -gt 0 ]]; then
                break
            fi

            # Find all subdirectories (not hidden)
            dirs=()
            while IFS= read -r -d $'\0' dir; do
                dirs+=("$dir")
            done < <(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -print0)

            # If exactly one subdirectory, and it's where we just came from
            if [[ ${#dirs[@]} -eq 1 ]]; then
                only_dir="$(cd "${dirs[0]}" && pwd)"
                if [[ "$only_dir" == "$prev_dir" ]]; then
                    prev_dir="$(pwd)"
                    cd .. || return
                    continue
                fi
            fi
            break
        done
    else
        cd -- "$1" || return
        while true; do
            # Check for files (not hidden)
            file_count=$(find . -mindepth 1 -maxdepth 1 -type f ! -name '.*' | wc -l)
            if [[ $file_count -gt 0 ]]; then
                break
            fi

            # Find all subdirectories (not hidden)
            dirs=()
            while IFS= read -r -d $'\0' dir; do
                dirs+=("$dir")
            done < <(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -print0)

            if [[ ${#dirs[@]} -eq 1 ]]; then
                cd -- "${dirs[0]}" || return
            else
                break
            fi
        done
    fi
}
alias cdz='cdzoom'

# Find a file with a pattern in name (taken from github/awdeorio/dotfiles):
ff() { 
    find . -type f -iwholename '*'$*'*' ;
}



# Take all text passed and flip / to \ and vice versa
flipslashes() {
    all_text="$*"
    forward_slashed="$(echo "$all_text" | sed 's/\\/\//g')"
    backwards_slashed="$(echo "$all_text" | sed 's/\//\\/g')"
    echo
    echo "Forwards slashed: '$forward_slashed'"
    echo "Bacwards slashed: '$backwards_slashed'"
}

###########################################################
# Support machine dependent bashrc additions
###########################################################

# Placed second to last so that these settings can override the above settings
# If placed after PS1 settings, the colors will be off in some cases
PS1="\[\033[01;38;5;130m\][\h:\w] ...\n$ \[\033[0m\]"

if [ -d "$HOME/private_dotfiles" ]; then
    . "$HOME/private_dotfiles/bashrc"
fi

# Old naming "local" kept for compatibility
if [ -d "$HOME/local_dotfiles" ]; then
    . "$HOME/local_dotfiles/bashrc"
fi


