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

if $IS_UBUNTU; then
  sudo apt install -y nala
  sudo nala install -y bash zsh eza zip unzip git ripgrep dos2unix fd-find zsh-syntax-highlighting zsh-autosuggestions
fi

mkdir -p ~/github

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install fzf
FZF_VERSION=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz"  
tar xf fzf.tar.gz -C $HOME/.local/bin
rm -rf fzf.tar.gz

# Install oh-my-posh
curl -sS https://ohmyposh.dev/install.sh | sh

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t $HOME/.local/bin
rm -rf lazygit*

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64.tar.gz
ln -s /opt/nvim-linux-x86_64/bin/nvim $HOME/.local/bin/nvim

# Add Zscalar certs
echo ""
read -p "Configure Zscalar certificate? (Y/N): " zconfirm
if [[ "$zconfirm" == "Y" ]] && [[ -z $winhome ]]; then
  read -p "Windows home folder name (The name is case sensitive): " winhome
fi
if [[ "$zconfirm" == "Y" ]]; then
  if $IS_UBUNTU && [[ ! -f /usr/local/share/ca-certificates/ZscalerRootCA.crt ]]; then
    echo ">>> Handling ZScalar certificate for Ubuntu"
    if [[ -f "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" ]]; then
      echo ">>> Adding ZscalarRootCA to the certs"
      sudo nala install -y ca-certificates
      sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /usr/local/share/ca-certificates
      sudo update-ca-certificates
    fi
  elif $IS_SUSE && [[ ! -f /usr/share/pki/trust/anchors/ZscalerRootCA.crt ]]; then
    echo ">>> Handling ZScalar certificate for SUSE"
    if [[ -f "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" ]]; then
      echo ">>> Adding ZscalarRootCA to the certs"
      sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /usr/share/pki/trust/anchors/ZscalerRootCA.crt
      sudo update-ca-certificates
    fi
  elif $IS_FEDORA && [[ ! -f /etc/pki/ca-trust/source/anchors/ZscalerRootCA.crt ]]; then
    echo ">>> Handling ZScalar certificate for Fedora"
    if [[ -f "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" ]]; then
      echo ">>> Adding ZscalarRootCA to the certs"
      sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /etc/pki/ca-trust/source/anchors/ZscalerRootCA.crt
      sudo update-ca-trust
    fi
  fi
fi
