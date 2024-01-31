#!/usr/bin/env bash

# Figure out if this is fedora/ubuntu
source /etc/os-release
echo ">>>> Linux OS Release: $PRETTY_NAME"

# Set Flags
if [[ $PRETTY_NAME == *"Ubuntu"* ]]; then
	export IS_UBUNTU=true
	export IS_FEDORA=false
elif [[ $PRETTY_NAME == *"Fedora"* ]]; then
	export IS_FEDORA=true
	export IS_UBUNTU=false
fi

# Update the apt package list.
if $IS_UBUNTU; then
	sudo apt update -y
	sudo apt install -y zip unzip dos2unix zsh htop git fzf autojump
elif $IS_FEDORA; then
	sudo dnf upgrade
	sudo dnf install -y zip unzip dos2unix htop git fzf autojump
	sudo dnf install -y dnf-plugins-core
	sudo dnf copr enable -y kopfkrieg/diff-so-fancy
	sudo dnf install -y diff-so-fancy
fi

# Add Zscalar certs
echo ""
read -p "Configure Zscalar certificate? (Y/N): " zconfirm
if [[ "$zconfirm" == "Y" ]] && [[ ! -f /usr/local/share/ca-certificates/ZscalerRootCA.crt ]]; then
	if $IS_UBUNTU; then
		if [[ -z $winhome ]]; then
			read -p "Windows home folder name (The name is case sensitive): " winhome
		fi
		if [[ -f "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" ]]; then
			echo ">>> Adding ZscalarRootCA to the certs"
			sudo apt install -y ca-certificates
			sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /usr/local/share/ca-certificates
			sudo update-ca-certificates
		fi
	fi
fi

# Fix bash_profile file
if [[ ! -f ~/.bash_profile ]]; then
	touch ~/.bash_profile
fi
if ! grep -q "# Load .bashrc" "~/.bash_profile"; then
	echo "# Load .bashrc" >> ~/.bash_profile
	echo "if [ -r ~/.bashrc ]; then . ~/.bashrc; fi" >> ~/.bash_profile
fi
