#!/usr/bin/env bash

# Install ZSH
# sudo apt install -y zsh
# sudo dnf install -y zsh

###################################################
# ZSH Setup
# https://dev.to/hbenvenutti/using-zsh-without-omz-4gch
###################################################
mkdir ~/.zsh ~/.zsh/plugins ~/.zsh/themes
rm ~/.zsh_history
touch ~/.zsh/.zsh_history

### ---- Spaceship Theme ----
cd ~/.zsh/themes
git clone git@github.com:spaceship-prompt/spaceship-prompt.git

### ---- Plugins ----
cd ~/.zsh/plugins
git clone git@github.com:zdharma-zmirror/fast-syntax-highlighting.git
git clone git@github.com:zsh-users/zsh-autosuggestions.git
git clone git@github.com:zsh-users/zsh-completions.git

### ---- Set ZSH as default ----
chsh -s $(which zsh)
