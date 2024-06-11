#!/bin/bash 

###########################################################
# autojump
###########################################################
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh
[[ -s /usr/share/autojump/autojump.sh ]] && . /usr/share/autojump/autojump.sh

###########################################################
# aliases
###########################################################

# used to visually separate old commands from new ones
alias sep="printf '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n' \
    && printf '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n' \
    && printf '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n' \
    && printf '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n' \
    && printf '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n' \
    && reset"

# force removal of vim swp files
alias snuke="ls -a | grep '^\..*\.sw[ponmlkjih]$' | xargs rm"

# search all files for some pattern. the pattern follows the 'showme'
alias showme="grep -rnw . -e " 

# used to login into my virtualbox vm
alias vmlogin="ssh -p 3022 "$USER"@127.0.0.1"

# "ls -l" but the octal permission values are prepended to each line
# taken from https://askubuntu.com/questions/152001/how-can-i-get-octal-file-permissions-from-command-line
lso() { ls -alG "$@" | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print}'; }


# print out disk usage for everything in cwd and sort the results
SORT=sort
if [ "$(uname)" = Darwin ]; then 
    SORT=gsort
fi
alias dus='du -sh * | "$SORT" -h'

# ls syntax varies
if [ "$(uname)" = "Darwin" ]; then
    alias ls='ls -G'
elif [ "$(uname)" = "Linux" ]; then
    alias ls='ls --color'
fi


alias l='ls -lrt'
alias m="make"
alias p="python"
alias g="git"
alias v="iverilog"
alias p3="python3"
alias grep="grep --color"
alias egrep="egrep --color"
alias fgrep="fgrep --color"
alias cheat="vim ~/.cheatsheet"
alias lcheat="vim ~/local_dotfiles/cheatsheet"

find_ctx_root() {
    local sentinel="$1"
    start_dir="$(pwd)"

    ls_command=""
    if [ "$(uname)" = "Darwin" ]; then
        ls_command="ls -a"
    else
        # turn off coloring so grep regex works as intended
        ls_command="ls --color=never -a"
    fi

    # Try to find a directory above us which has file or directory $sentinel
    # If we don't find one, return the directory we started with
    cwd="$start_dir"
    while [ "$cwd" != '/' ]; do
        if [ ! -z "$($ls_command | grep "$sentinel")" ]; then
            cd "$start_dir"
            echo "$cwd"
            return
        fi

        cd ..
        cwd="$(pwd)"
    done

    cd "$start_dir"
    echo "$start_dir"
}

git_root() {
    echo "$(find_ctx_root '^\.git$')"
}

# Sourcing/Exporting
alias e='export'
alias eg='export GOPATH="$(git_root)"'
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
alias emwbashrc='vim ~/local_dotfiles/bashrc'


double_autojump() {
    arg="$1"
    cd "$(autojump "$arg")"
    cd "$(autojump "$arg")"
}

alias jj='double_autojump' 

# Jump up to a project's root
alias rb='cd "$(git_root)"'

# update dotfiles, symlink any new ones, and update vim plugins
alias dotdate="sh ~/dotfiles/update.sh && . ~/.bashrc"

# Find a file with a pattern in name (taken from github/awdeorio/dotfiles):
ff() { 
    find . -type f -iwholename '*'$*'*' ;
}

###########################################################
# Support machine dependent bashrc additions
###########################################################

# Placed second to last so that these settings can override the above settings
# If placed after PS1 settings, the colors will be off in some cases

# Include local customizations in .local_bashrc. Kept for compatibility.
if [ -f "$HOME/.local_bashrc" ]; then
    . "$HOME/.local_bashrc"
fi

# The preferred way to store local configuration, since it can also be packaged as a repo
if [ -d "$HOME/local_dotfiles" ]; then
    . "$HOME/local_dotfiles/bashrc"
fi

###########################################################
# Detect the machine id and use the corresponding PS1
###########################################################

dotfiles_path="$HOME/dotfiles"

# the machine id stored in the file dotfiles/machine_id, which is populated by 
# the user defined value during setup
if [ -f "$dotfiles_path/machine_id" ]; then
    machine_id="$(cat "$dotfiles_path/machine_id")"
    case "$machine_id" in 
        "osx_laptop")
            # purple PS1
            PS1="\[\033[01;38;5;140m\]osx$ \w: \[\033[0m\]"
            ;;
        "caen")
            # orange PS1
            PS1="\[\033[01;38;5;130m\]caen$ \w: \[\033[0m\]"
            ;;
        "research")
            # yellow PS1
            PS1='\[\e[1;33m\]research$ \w: \[\e[0m\]'
            ;;
        "mathworks-desktop")
            # orange PS1
            PS1="\[\033[01;38;5;130m\][\h:\w] ...\n$ \[\033[0m\]"
            ;;
        "mathworks-laptop")
            # yellow PS1
            PS1='\[\e[1;33m\][\h:\w] ...\n$ \[\e[0m\]'
            ;;
        "vagrant")
            # green PS1
            PS1='\[\e[1;32m\]vagrant$ \w: \[\e[0m\]'
            ;;
        *)
            # orange PS1
            PS1="\[\033[01;38;5;130m\]${machine_id}$ \w: \[\033[0m\]"
            ;;
    esac
fi

