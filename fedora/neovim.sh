#!/usr/bin/env bash

sudo dnf install -y gcc make git ripgrep fd-find unzip neovim

git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
