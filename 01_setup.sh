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
	sudo apt install -y zip unzip dos2unix htop git
	# Install homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
elif $IS_FEDORA; then
	sudo dnf upgrade
	sudo dnf install -y zip unzip dos2unix htop git fzf
	sudo dnf install -y dnf-plugins-core
	sudo dnf copr enable -y kopfkrieg/diff-so-fancy
	sudo dnf install -y diff-so-fancy
fi

# Git Configuration
echo ""
read -p "Configure Git? (Y/N): " gitconfirm
if [[ "$gitconfirm" == "Y" ]]; then
	read -p "Git User Name (Firstname Lastname): " gitname
	read -p "Git User Email (firstlastname@crsoftware.com): " gitemail
	git config --global user.name "$gitname"
	git config --global user.email "$gitemail"

	git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
	git config --global color.ui true

	git config --global color.diff-highlight.oldNormal    "red bold"
	git config --global color.diff-highlight.oldHighlight "red bold 52"
	git config --global color.diff-highlight.newNormal    "green bold"
	git config --global color.diff-highlight.newHighlight "green bold 22"

	git config --global color.diff.meta       "11"
	git config --global color.diff.frag       "magenta bold"
	git config --global color.diff.commit     "yellow bold"
	git config --global color.diff.old        "red bold"
	git config --global color.diff.new        "green bold"
	git config --global color.diff.whitespace "red reverse"
else
	echo ">>>> Skip Git Configuration"
fi

echo ""
read -p "Copy ssh keys (id_ed25519) from Windows? (Y/N): " winconfirm
if [[ "$gitconfirm" == "Y" ]]; then
	if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
		echo ">>>> SSH keys are already present, skipping"
	else
		read -p "Windows home folder name (The name is case sensitive): " winhome
		mkdir -p $HOME/.ssh
		cp -r /mnt/c/Users/$winhome/config/ssh/id_ed25519* $HOME/.ssh
		dos2unix $HOME/.ssh/id_ed25519*
		chmod 600 $HOME/.ssh/id_ed25519*

		echo ">>>> SSH keys copied"
	fi
else
	echo ">>>> Skip ssh keys setup from windows"
fi

# Install fzf
sudo apt-get install -y fzf

# Add homebrew
if $IS_UBUNTU; then
	test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
	test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc

	brew install diff-so-fancy
fi

# Add alias file
if ! grep -q "# Load user alias and functions" "$SHELL_FILE"; then
    echo "" >> $SHELL_FILE
    echo "# Load user alias and functions" >> $SHELL_FILE
    echo "source $HOME/linux-config/user_functions.sh" >> $SHELL_FILE
    echo "source $HOME/linux-config/user_alias.sh" >> $SHELL_FILE
else
    echo ">>>> User Alias already present in $SHELL_FILE"
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
