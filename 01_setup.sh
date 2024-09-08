#!/usr/bin/env bash

# Figure out if this is fedora/ubuntu
source /etc/os-release
echo ">>>> Linux OS Release: $PRETTY_NAME"

# Set Flags
if [[ $PRETTY_NAME == *"Ubuntu"* ]]; then
	export IS_UBUNTU=true
	export IS_FEDORA=false
	export IS_SUSE=false
elif [[ $PRETTY_NAME == *"Fedora"* ]]; then
	export IS_FEDORA=true
	export IS_UBUNTU=false
	export IS_SUSE=false
elif 
	[[ $PRETTY_NAME == *"openSUSE"* ]]; then
	export IS_SUSE=true
	export IS_FEDORA=false
	export IS_UBUNTU=false
fi

# Update the apt package list.
if $IS_UBUNTU; then
	echo ">>> Install Ubuntu Packages"
	sudo apt update -y
	sudo apt install -y zip unzip dos2unix zsh htop git autojump zsh jq zoxide
elif $IS_FEDORA; then
	echo ">>> Install Fedora Packages"
	sudo dnf upgrade
	sudo dnf install -y zip unzip dos2unix htop git autojump zsh jq
	sudo dnf install -y dnf-plugins-core
	sudo dnf copr enable -y kopfkrieg/diff-so-fancy
	sudo dnf install -y diff-so-fancy
elif $IS_SUSE; then
	echo ">>> Install openSUSE Packages"
	sudo zypper ref
	sudo zypper list-updates --all
	sudo zypper -n update
	sudo zypper -n install zip unzip dos2unix htop git autojump diff-so-fancy jq
fi

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install ohmyposh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Add Zscalar certs
echo ""
read -p "Configure Zscalar certificate? (Y/N): " zconfirm
if [[ "$zconfirm" == "Y" ]] && [[ -z $winhome ]]; then
	read -p "Windows home folder name (The name is case sensitive): " winhome
fi
if [[ "$zconfirm" == "Y" ]]; then
	if $IS_UBUNTU && [[ ! -f /usr/local/share/ca-certificates/ZscalerRootCA.crt ]]; then
		if [[ -f "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" ]]; then
			echo ">>> Adding ZscalarRootCA to the certs"
			sudo apt install -y ca-certificates
			sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /usr/local/share/ca-certificates
			sudo update-ca-certificates
		fi
	elif $IS_SUSE && [[ ! -f /usr/share/pki/trust/anchors/ZscalerRootCA.crt ]]; then
		if [[ -f "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" ]]; then
			echo ">>> Adding ZscalarRootCA to the certs"
			sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /usr/share/pki/trust/anchors/ZscalerRootCA.crt
			sudo update-ca-certificates
		fi
	elif $IS_FEDORA && [[ ! -f /etc/pki/ca-trust/source/anchors/ZscalerRootCA.crt ]]; then
		if [[ -f "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" ]]; then
			echo ">>> Adding ZscalarRootCA to the certs"
			sudo cp "/mnt/c/Users/$winhome/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" /etc/pki/ca-trust/source/anchors/ZscalerRootCA.crt
			sudo update-ca-trust
		fi
	fi
fi
