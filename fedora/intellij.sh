#!/usr/bin/env bash

idea_version='2024.2.1'
use_ultimate='false'
use_community='false'
remove_existing='false'

help_message() {
  echo
  echo "Usage: $(basename $0) [-v 2024.2.0.2] [-u] [-c] [-r] [-h]"
  echo "options:"
  echo "h     Print the Help Message."
  echo "v     Intellij Version."
  echo "u     Use Ultimate Version."
  echo "c     Use Community Version."
  echo "r     Remove exising install."
  echo
}

while getopts ':v:curh' opt; do
  case "$opt" in
    v)
      build_version="$OPTARG"
      echo "Using Build Number = ${OPTARG}"
      ;;

    u)
      use_ultimate='true'
      echo "Using Intellij Ultimate Version"
      ;;

    c)
      use_community='true'
      echo "Using Intellij Community Version"
      ;;

    r)
      remove_existing='true'
      echo "Removing existing Intellij from $HOME/.jetbrains"
      ;;

    h)
      help_message
      exit 1
      ;;

    :)
      echo -e "Option requires an argument.\nUsage: $(basename $0) [-v 2024.2.0.2] [-u] [-h]"
      exit 1
      ;;

    ?)
      echo -e "Invalid command option.\nUsage: $(basename $0) [-v 2024.2.0.2] [-u] [-h]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if [[ "$remove_existing" == 'true' ]]; then
    # Delete previous installs
    rm -rf ~/.jetbrains
else
    mkdir -p ~/.jetbrains/software

    sysctl_file='/etc/sysctl.conf'
    file_watches_string='fs.inotify.max_user_watches=1048576'

    if ! grep -q -F "$file_watches_string" "$sysctl_file"; then
        echo "$file_watches_string" | sudo tee -a $sysctl_file
        sudo sysctl -p # reload the config
    fi

    # Install required software
sudo dnf install -y gnome-software
fi

# Find download link from https://www.jetbrains.com/idea/download/other.html

if [[ "$use_ultimate" == 'true' ]]; then
    wget https://download.jetbrains.com/idea/ideaIU-$idea_version.tar.gz -P ~/.jetbrains
    tar -zxvf ~/.jetbrains/ideaIU-$idea_version.tar.gz -C ~/.jetbrains/software
    rm -f ~/.jetbrains/ideaIU-$idea_version.tar.gz 
    ln -s ~/.jetbrains/software/idea-IU* ~/.jetbrains/ideau
fi

if [[ "$use_community" == 'true' ]]; then
    wget https://download.jetbrains.com/idea/ideaIC-$idea_version.tar.gz -P ~/.jetbrains
    tar -zxvf ~/.jetbrains/ideaIC-$idea_version.tar.gz -C ~/.jetbrains/software
    rm -f ~/.jetbrains/ideaIC-$idea_version.tar.gz 
    ln -s ~/.jetbrains/software/idea-IC* ~/.jetbrains/ideac
fi

ls -l ~/.jetbrains
