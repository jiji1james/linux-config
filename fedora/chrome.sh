#!/usr/bin/env bash

wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf install -y ./google-chrome-stable_current_x86_64.deb
sudo rm -f ./google-chrome-stable_current_x86_64.deb
