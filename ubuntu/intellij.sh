#!/usr/bin/env bash

version='2024.2.0.1'

mkdir ~/.jetbrains
rm -f ~/.jetbrains/idea

sudo apt install -y gnome-software

# Find download link from https://www.jetbrains.com/idea/download/other.html
wget https://download.jetbrains.com/idea/ideaIU-$version.tar.gz -P ~/.jetbrains

tar -zxvf ~/.jetbrains/ideaIU-$version.tar.gz -C ~/.jetbrains
rm ~/.jetbrains/ideaIU-$version.tar.gz 

ln -s ~/.jetbrains/idea-IU* ~/.jetbrains/idea
ls -l ~/.jetbrains
