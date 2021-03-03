#!/bin/bash 

###########################################################
# Support machine dependent bashrc additions
###########################################################

# all per-system bashrc customizations are put in dotfiles/bashrc_local
if [ -f "$HOME/.local_bashrc" ]; then
    . "$HOME/.local_bashrc"
fi

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

alias falcone="ssh colton@alabxeon.eecs.umich.edu"
alias team583="ssh team583@alabxeon.eecs.umich.edu"
alias cssh='ssh choloday@eecs583b.eecs.umich.edu'
alias dijkstra='ssh -Y choloday@dijkstra.eecs.umich.edu'
alias deadshot='ssh choloday@deadshot.eecs.umich.edu'
alias cook1='ssh choloday@cook1.eecs.umich.edu'
alias rapidan='ssh choloday@rapidan.eecs.umich.edu'
alias hopper='ssh choloday@hopper.eecs.umich.edu'
alias liskov='ssh choloday@liskov.eecs.umich.edu'


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

alias m="make"
alias p="python"
alias g="git"
alias v="iverilog"
alias p3="python3"
alias grep="grep --color"
alias egrep="egrep --color"
alias fgrep="fgrep --color"
alias cheat="vim ~/.cheatsheet"

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
alias se='. "$(git_root)"/env/bin/activate'
alias sb=". ~/.bashrc"


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
        "vagrant")
            # green PS1
            PS1='\[\e[1;32m\]vagrant$ \w: \[\e[0m\]'
            ;;
        *)
            # blue PS1
            PS1="\[\033[01;38;5;130m\]${machine_id}$ \w: \[\033[0m\]"
            ;;
    esac
fi

###########################################################
# Mathworks Configuration
###########################################################

if [ -f "$dotfiles_path/machine_id" ]; then
    machine_id="$(cat "$dotfiles_path/machine_id")" 
    if [ "$machine_id" = ah-choloday-l ]; then
        . /mathworks/hub/share/sbtools/bash_setup.bash

        # Perforce colorschemes
        export P4COLORS="@info=0:@error=31;1:@warning=35;1:action=36;1:how:36:change=34:depotFile=32:path=32:location=32:rev=31:depotRev=31"
        #   export P4COLORS="@info=0:@error=31;1:@warning=35;1:action=36;1:how:36:change=33:depotFile=32:path=32:location=32:rev=31:depotRev=31"
    fi
fi
