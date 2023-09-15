#!/usr/bin/env bash

# Update the list of packages
sudo apt-get update -y

# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common

# Download the Microsoft repository GPG keys
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"

# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com
sudo apt-get update -y

# Install PowerShell
sudo apt-get install -y powershell

# Delete temp file
rm packages-microsoft-prod.deb

# Start PowerShell
pwsh