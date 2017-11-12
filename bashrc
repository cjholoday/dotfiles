#!bin/sh 

###########################################################
# Support machine dependent bashrc additions
###########################################################

# all per-system bashrc customizations are put in dotfiles/bashrc_local
if [ -f "~/.local_bashrc" ]; then
    . "~/.local_bashrc"
fi

###########################################################
# autojump
###########################################################
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh


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


# ls syntax varies
if [ "$(uname)" = "Darwin" ]; then
    alias ls='ls -G'
elif [ "$(uname)" = "Linux" ]; then
    alias ls='ls --color'
fi

alias m="make"
alias p="python"
alias g="git"
alias p3="python3"
alias grep="grep --color"
alias egrep="egrep --color"
alias fgrep="fgrep --color"
alias cheat="vim ~/.cheatsheet"

function set_gopath {
    start_dir="$(pwd)"

    # Try to find the root of a git repository above us. If we find one,
    # set the path to it as our GOPATH. Otherwise, set GOPATH to our CWD
    cwd="$start_dir"
    while [ "$cwd" != '/' ]; do
        if [ ! -z "$(ls -a | grep '^\.git')" ]; then
            export GOPATH="$cwd"
            cd "$start_dir"
            return
        fi

        cd ..
        cwd="$(pwd)"
    done

    export GOPATH="$start_dir"
    cd "$start_dir"
}

# Sourcing/Exporting
alias eg="set_gopath"
alias se='. env/bin/activate'
alias sb=". ~/.bashrc"

# update dotfiles, symlink any new ones, and update vim plugins
alias dotdate="pushd $HOME/dotfiles; \
    git pull origin master; \
    bash setup.sh; \
    bash upgrade_vim.sh; \
    . $HOME/.bashrc; \
    popd"

# Find a file with a pattern in name (taken from github/awdeorio/dotfiles):
function ff() { 
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
            PS1='\[\e[1;36m\]\w: \[\e[0m\]'
            ;;
    esac
else
    printf "Error: Run the dotfiles setup script before using .bashrc!\n"
fi
