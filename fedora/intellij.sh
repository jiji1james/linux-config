#!/usr/bin/env bash

idea_version='2024.2.3'
use_ultimate='true'
use_community='true'
remove_existing='true'

jetbrains_folder="$HOME/.jetbrains"
jetbrains_software_folder="$jetbrains_folder/software"

if [[ "$remove_existing" == 'true' ]]; then
    echo ">>> Deleting existing install: $jetbrains_software_folder"
    rm -rf $jetbrains_software_folder

    echo ">>> Creating folder again: $jetbrains_software_folder"
    mkdir -p $jetbrains_software_folder
else
    sysctl_file='/etc/sysctl.conf'
    file_watches_string='fs.inotify.max_user_watches=1048576'

    if ! grep -q -F "$file_watches_string" "$sysctl_file"; then
        echo ">>> Updating the allowed file watches count"
        echo "$file_watches_string" | sudo tee -a $sysctl_file
        sudo sysctl -p # reload the config
        # Install required software
        sudo dnf install -y nautilus
    fi
fi

# Find download link from https://www.jetbrains.com/idea/download/other.html

if [[ "$use_ultimate" == 'true' ]]; then
    echo ">>> Installing ultimate version of Intellij $idea_version in $jetbrains_software_folder"

    wget https://download.jetbrains.com/idea/ideaIU-$idea_version.tar.gz -P $jetbrains_software_folder

    tar -zxvf $jetbrains_software_folder/ideaIU-$idea_version.tar.gz -C $jetbrains_software_folder
    rm -f $jetbrains_software_folder/ideaIU-$idea_version.tar.gz 
    ln -s $jetbrains_software_folder/idea-IU* $jetbrains_folder/ideau
fi

if [[ "$use_community" == 'true' ]]; then
    echo ">>> Installing community version of Intellij $idea_version in $jetbrains_software_folder"

    wget https://download.jetbrains.com/idea/ideaIC-$idea_version.tar.gz -P $jetbrains_software_folder

    tar -zxvf $jetbrains_software_folder/ideaIC-$idea_version.tar.gz -C $jetbrains_software_folder
    rm -f $jetbrains_software_folder/ideaIC-$idea_version.tar.gz 
    ln -s $jetbrains_software_folder/idea-IC* $jetbrains_folder/ideac
fi

echo ">>> Add below entries to the .zshrc file if needed"
echo 'alias ideac="$HOME/.jetbrains/ideac/bin/idea"'
echo 'alias ideau="$HOME/.jetbrains/ideau/bin/idea"'

ls -l $HOME/.jetbrains

