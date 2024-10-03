#!/usr/bin/env bash

idea_version='2024.2.3'
use_ultimate='false'
use_community='false'
remove_existing='false'

help_message() {
  echo
  echo "Usage: $(basename $0) [-v $idea_version] [-u] [-c] [-r] [-h]"
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
      echo "Option -$OPTARG requires and argument"
      help_message
      exit 1
      ;;
    \?)
      echo "Invalid command option -$OPTARG"
      help_message
      exit 1
      ;;
  esac
done
shift $(($OPTIND -1))

if [[ "$remove_existing" == 'true' ]]; then
    echo ">>> Deleting exiting install"
    sudo rm -rf /opt/jetbrains/ideac
    sudo rm -rf /opt/jetbrains/idea-IC*
else
    sysctl_file='/etc/sysctl.conf'
    file_watches_string='fs.inotify.max_user_watches=1048576'

    if ! grep -q -F "$file_watches_string" "$sysctl_file"; then
        echo "$file_watches_string" | sudo tee -a $sysctl_file
        sudo sysctl -p # reload the config
        # Install required software
        sudo dnf install -y gnome-software
    fi
fi

# Find download link from https://www.jetbrains.com/idea/download/other.html

if [[ "$use_ultimate" == 'true' ]]; then
    echo ">>> Installing ultimate version of Intellij $idea_version in /opt"

    wget https://download.jetbrains.com/idea/ideaIU-$idea_version.tar.gz -P ~

    sudo mkdir -p /opt/jetbrains/
    sudo mv ~/ideaIU-$idea_version.tar.gz /opt/jetbrains
    sudo tar -zxvf /opt/jetbrains/ideaIU-$idea_version.tar.gz -C /opt/jetbrains
    sudo rm -f /opt/jetbrains/ideaIU-$idea_version.tar.gz 
    sudo ln -s /opt/jetbrains/idea-IU* /opt/jetbrains/ideau
fi

if [[ "$use_community" == 'true' ]]; then
    echo ">>> Installing community version of Intellij $idea_version in /opt"

    wget https://download.jetbrains.com/idea/ideaIC-$idea_version.tar.gz -P ~

    sudo mkdir -p /opt/jetbrains/
    sudo mv ~/ideaIC-$idea_version.tar.gz /opt/jetbrains
    sudo tar -zxvf /opt/jetbrains/ideaIC-$idea_version.tar.gz -C /opt/jetbrains
    sudo rm -f /opt/jetbrains/ideaIC-$idea_version.tar.gz 
    sudo ln -s /opt/jetbrains/idea-IC* /opt/jetbrains/ideac
fi

ls -l /opt/jetbrains

