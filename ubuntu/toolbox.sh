#!/usr/bin/env bash

mkdir -p ~/.jetbrains/software

sysctl_file='/etc/sysctl.conf'
file_watches_string='fs.inotify.max_user_watches=1048576'

if ! grep -q -F "$file_watches_string" "$sysctl_file"; then
	echo "$file_watches_string" | sudo tee -a $sysctl_file
        sudo sysctl -p # reload the config
fi

# Find download link from https://www.jetbrains.com/idea/download/other.html
sudo apt install -y libfuse2
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz

sudo rm -rf /opt/jetbrains/toolbox
sudo mkdir -p /opt/jetbrains/toolbox

sudo tar -xzvf jetbrains-toolbox-2.4.2.32922.tar.gz -C /opt/jetbrains/toolbox
sudo ln -sf /opt/jetbrains/toolbox/jetbrains-toolbox-2.4.2.32922 /opt/jetbrains/jetbrains-toolbox


