#!/usr/bin/env bash

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf config-manager --add-repo https://packages.microsoft.com/rhel/8/prod/
sudo dnf install -y powershell

pwsh    