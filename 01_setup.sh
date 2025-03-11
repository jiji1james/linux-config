#!/usr/bin/env bash

# Figure out if this is fedora/ubuntu
source /etc/os-release
echo ">>>> Linux OS Release: $PRETTY_NAME"

# Set Flags
if [[ $PRETTY_NAME == *"Ubuntu"* || $PRETTY_NAME == *"Kali"* ]]; then
  export IS_UBUNTU=true
  export IS_FEDORA=false
  export IS_SUSE=false
elif [[ $PRETTY_NAME == *"Fedora"* ]]; then
  export IS_FEDORA=true
  export IS_UBUNTU=false
  export IS_SUSE=false
elif [[ $PRETTY_NAME == *"openSUSE"* ]]; then
  export IS_SUSE=true
  export IS_FEDORA=false
  export IS_UBUNTU=false
fi

echo ""
echo "UBUNTU  : $IS_UBUNTU"
echo "FEDORA  : $IS_FEDORA"
echo "SUSE    : $IS_SUSE"

echo ">>> Installing basic software"
if $IS_UBUNTU; then
  sudo apt install -y nala
  sudo nala install -y bash zsh eza zip unzip git ripgrep dos2unix tmux fd-find build-essential zsh-syntax-highlighting zsh-autosuggestions libfuse2
  
  # Install diff-so-fancy using node
  sudo nala install -y nodejs npm
  # Install diff-so-fancy globally
  sudo npm install -g diff-so-fancy
elif $IS_FEDORA; then
  sudo dnf install -y bash zsh eza zip unzip git ripgrep dos2unix tmux fd-find diff-so-fancy zsh-syntax-highlighting zsh-autosuggestions gcc libfuse2
elif $IS_SUSE; then
  sudo zypper install -y bash zsh eza zip unzip git ripgrep dos2unix tmux fd-find zsh-syntax-highlighting zsh-autosuggestions gcc libfuse2
fi

mkdir -p ~/github
mkdir -p ~/.local/bin
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
fi

# Add Zscalar certs
echo ""
if [[ -f /usr/local/share/ca-certificates/ZscalerRootCA.crt || -f /usr/share/pki/trust/anchors/ZscalerRootCA.crt || -f /etc/pki/ca-trust/source/anchors/ZscalerRootCA.crt ]]; then
  echo ">>> Zscaler Root CA already exists"
else
  echo ">>> Zscaler Root CA does not exist"
  echo ""
  read -p "Windows home folder name (The name is case sensitive): " winhome
  echo ""
  echo ">>> Installing Zscaler Root CA"
  
  if $IS_UBUNTU; then
    sudo nala install -y ca-certificates
    sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /usr/local/share/ca-certificates/ZscalerRootCA.crt
    sudo update-ca-certificates
  elif $IS_FEDORA; then
    sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /etc/pki/ca-trust/source/anchors/ZscalerRootCA.crt
    sudo update-ca-trust
  elif $IS_SUSE; then
    sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /usr/share/pki/trust/anchors/ZscalerRootCA.crt
    sudo update-ca-certificates
  fi
fi

# Install zoxide
echo ""
echo ">>> Checking zoxide installation"
if ! command -v zoxide &> /dev/null; then
  echo ">>> Installing zoxide"
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo ">>> zoxide is already installed at $(command -v zoxide)"
fi

# Install fzf
echo ""
echo ">>> Checking fzf installation"
if ! command -v fzf &> /dev/null; then
  echo ">>> Installing fzf"
  FZF_VERSION=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz"
  tar xf fzf.tar.gz -C $HOME/.local/bin
  rm -rf fzf.tar.gz
  echo ">>> fzf has been installed"
else
  echo ">>> fzf is already installed at $(command -v fzf)"
fi

# Install Oh My Posh
echo ""
echo ">>> Checking oh-my-posh installation"
if ! command -v oh-my-posh &> /dev/null; then
  echo ">>> Installing Oh My Posh"
  curl -s https://ohmyposh.dev/install.sh | bash -s
else
  echo ">>> Oh My Posh is already installed at $(command -v oh-my-posh)"
fi

# Install lazygit
echo ""
echo ">>> Checking lazygit installation"
if ! command -v lazygit &> /dev/null; then
  echo ">>> Installing lazygit"
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t $HOME/.local/bin
  rm -rf lazygit*
else
  echo ">>> lazygit is already installed at $(command -v lazygit)"
fi

# Install neovim
echo ""
echo ">>> Checking neovim installation"
if ! test -f $HOME/.local/bin/nvim; then
  echo ">>> Installing neovim"
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm -rf nvim-linux-x86_64.tar.gz
  ln -s /opt/nvim-linux-x86_64/bin/nvim $HOME/.local/bin/nvim
else
  echo ">>> neovim is already installed at $(command -v nvim)"
fi
