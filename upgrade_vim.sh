#!bin/sh
#
# A script for setting up and updating vim plugins

# only install the plugin manager if it hasn't already been installed. This allows
# us to use this bash script to update plugins as well as install them

if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

# all other plugins go in .vim/bundle
cd ~/.vim/bundle

plugin_repos=""
plugin_repos="$plugin_repos https://github.com/airblade/vim-gitgutter.git"
plugin_repos="$plugin_repos https://github.com/bling/vim-airline"
plugin_repos="$plugin_repos https://github.com/fatih/vim-go"
plugin_repos="$plugin_repos https://github.com/easymotion/vim-easymotion"

set -p # disable globbing
for plugin_repo in $plugin_repos; do
    # remove everything up to and including the last '/'
    repo_name="$(basename "$plugin_repo")"

    # remove the .git extension, if there is one
    repo_name="$(echo "$repo_name" | cut -f 1 -d '.')"

    # install the plugin or update it if it's already installed
    if [ -d ~/.vim/bundle/"$repo_name" ]; then
        cd ~/.vim/bundle/"$repo_name"
        git pull origin master
        cd ..
    else
        git clone "$plugin_repo"
    fi
done
set +p # re-enable globbing

