#!/usr/bin/env bash

echo "Bash..."
rm -f ~/.bashrc
rm -f ~/.bash_profile
ln -s ~/linux-config/dotfiles/shell/bashrc ~/.bashrc
ln -s ~/linux-config/dotfiles/shell/bash_profile ~/.bash_profile

echo "Zsh..."
rm -f ~/.zshrc
ln -s ~/linux-config/dotfiles/shell/zshrc ~/.zshrc

echo "IdeaVim..."
rm -f ~/.ideavimrc
ln -s ~/linux-config/dotfiles/ideavim/ideavimrc ~/.ideavimrc

echo "Tmux..."
rm -f ~/.tmux.conf
ln -s ~/linux-config/dotfiles/tmux/tmux.conf ~/.tmux.conf

echo "Git..."
rm -f ~/.gitconfig
rm -f ~/.gitignore
rm -f ~/.gitattributes
ln -s ~/linux-config/dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/linux-config/dotfiles/git/gitignore ~/.gitignore
ln -s ~/linux-config/dotfiles/git/gitattributes ~/.gitattributes

echo "Done!"