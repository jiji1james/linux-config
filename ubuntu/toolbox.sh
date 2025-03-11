#!/usr/bin/env bash

sysctl_file='/etc/sysctl.conf'
file_watches_string='fs.inotify.max_user_watches=1048576'

if ! grep -q -F "$file_watches_string" "$sysctl_file"; then
  echo "$file_watches_string" | sudo tee -a $sysctl_file
  sudo sysctl -p # reload the config
fi

# Find download link & version from https://www.jetbrains.com/toolbox-app/download/other.html
version="2.5.2.35332"

# Remove existing
sudo rm -rf /opt/JetBrains/Toolbox
sudo mkdir -p /opt/JetBrains/Toolbox

# Download new
cd /opt/JetBrains/Toolbox
sudo wget "https://download.jetbrains.com/toolbox/jetbrains-toolbox-$version.tar.gz"
sudo tar -xzvf "jetbrains-toolbox-$version.tar.gz" -C .
sudo ln -sf /opt/JetBrains/Toolbox/jetbrains-toolbox-$version/jetbrains-toolbox /opt/JetBrains/Toolbox/jetbrains-toolbox
sudo rm -f "jetbrains-toolbox-$version.tar.gz"
