#!/usr/bin/env bash

idea_version='2024.2.0.2'

mkdir ~/.jetbrains
rm -f ~/.jetbrains/idea

sudo apt install -y gnome-software

# Find download link from https://www.jetbrains.com/idea/download/other.html
wget https://download.jetbrains.com/idea/ideaIU-$idea_version.tar.gz -P ~/.jetbrains

tar -zxvf ~/.jetbrains/ideaIU-$idea_version.tar.gz -C ~/.jetbrains
rm -f ~/.jetbrains/ideaIU-$idea_version.tar.gz 

ln -s ~/.jetbrains/idea-IU* ~/.jetbrains/idea
ls -l ~/.jetbrains

# https://www.jetbrains.com/toolbox-app/download/other.html
# wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz -P ~/.jetbrains
# tar -zxvf ~/.jetbrains/jetbrains-toolbox-2.4.2.32922.tar.gz -C ~/.jetbrains
# rm -f ~/.jetbrains/jetbrains-toolbox-2.4.2.32922.tar.gz
# ln -s ~/.jetbrains/jetbrains-toolbox-2.4.2.32922 ~/.jetbrains/toolbox