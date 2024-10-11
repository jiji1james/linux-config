#!/usr/bin/env bash

# Install some helper prerequisites
sudo apt install -y nautilus firefox

mkdir -p ~/.jetbrains/software

sysctl_file='/etc/sysctl.conf'
file_watches_string='fs.inotify.max_user_watches=1048576'

if ! grep -q -F "$file_watches_string" "$sysctl_file"; then
	echo "$file_watches_string" | sudo tee -a $sysctl_file
        sudo sysctl -p # reload the config
fi

# Find download link from https://www.jetbrains.com/idea/download/other.html
sudo apt install -y libfuse2

# Remove existing
rm -rf ~/.jetbrains/software/toolbox
mkdir -p ~/.jetbrains/software/toolbox

# Download new
cd ~/.jetbrains/software/toolbox
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz
tar -xzvf jetbrains-toolbox-2.4.2.32922.tar.gz -C .
ln -sf ~/.jetbrains/software/toolbox/jetbrains-toolbox-2.4.2.32922 ~/.jetbrains/jetbrains-toolbox
rm -f ~/.jetbrains/software/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz


