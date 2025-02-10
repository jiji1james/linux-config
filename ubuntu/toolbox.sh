#!/usr/bin/env bash

# Install Chrome
./chrome.sh

mkdir -p ~/.jetbrains/software

sysctl_file='/etc/sysctl.conf'
file_watches_string='fs.inotify.max_user_watches=1048576'

if ! grep -q -F "$file_watches_string" "$sysctl_file"; then
        echo "$file_watches_string" | sudo tee -a $sysctl_file
        sudo sysctl -p # reload the config
fi

# Install required software
sudo apt install -y gnome-software libfuse2

# Find download link & version from https://www.jetbrains.com/toolbox-app/download/other.html
version="2.5.2.35332"

# Remove existing
rm -rf ~/.jetbrains/software/toolbox
mkdir -p ~/.jetbrains/software/toolbox

# Download new
cd ~/.jetbrains/software/toolbox
wget "https://download.jetbrains.com/toolbox/jetbrains-toolbox-$version.tar.gz"
tar -xzvf "jetbrains-toolbox-$version.tar.gz" -C .
ln -sf ~/.jetbrains/software/toolbox/jetbrains-toolbox-$version ~/.jetbrains/jetbrains-toolbox
rm -f "jetbrains-toolbox-$version.tar.gz"
