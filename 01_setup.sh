#!/usr/bin/env bash

# Update the apt package list.
sudo apt update -y
sudo apt install -y zip unzip dos2unix htop


# Git Configuration
echo ""
read -p "Configure Git? (Y/N): " gitconfirm
if [[ "$gitconfirm" == "Y" ]]; then
	read -p "Git User Name (Firstname Lastname): " gitname
	read -p "Git User Email (firstlastname@crsoftware.com): " gitemail
	git config --global user.name "$gitname"
	git config --global user.email "$gitemail"
else
	echo ">>>> Skip Git Configuration"
fi

if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
	echo ">>>> SSH keys are already present, skipping"
else
	mkdir -p $HOME/.ssh
	cp -r /mnt/c/Users/JijiJames/config/ssh/id_ed25519* $HOME/.ssh
	dos2unix $HOME/.ssh/id_ed25519*
	chmod 600 $HOME/.ssh/id_ed25519*

	echo ">>>> SSH keys copied"
fi


# Linux SHELL Configuration
SHELL_NAME="bash"
SHELL_FILE="$HOME/.bashrc"
CURRENT_SHELL=$(which $SHELL)

if [[ $CURRENT_SHELL == *"bash" ]]; then
    SHELL_NAME="bash"
    SHELL_FILE="$HOME/.bashrc"
elif [[ $CURRENT_SHELL == *"zsh" ]]; then
    SHELL_NAME="zsh"
    SHELL_FILE="$HOME/.zshrc"
else
    echo ">>> Unknown $CURRENT_SHELL"
fi

echo ""
echo ">>>> Configuring Shell environment for $CURRENT_SHELL using configuration file $SHELL_FILE"

# Install fzf
sudo apt-get install -y fzf
if ! grep -q "# Load fzf configuration" "$SHELL_FILE"; then
    echo "" >> $SHELL_FILE
    echo "# Load fzf configuration" >> $SHELL_FILE
    echo "source /usr/share/doc/fzf/examples/key-bindings.$SHELL_NAME" >> $SHELL_FILE
    if [[ $SHELL_NAME = "zsh" ]]; then
        echo "source /usr/share/doc/fzf/examples/completion.$SHELL_NAME" >> $SHELL_FILE
    fi
else
    echo ">>>> FZF config already present in $SHELL_FILE"
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
echo ">>>> Configuring Zscalar certificate, if present"
if [[ "$(uname -s)" == "Linux" ]] && [[ -f "/mnt/c/Users/JijiJames/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt" ]]; then
	echo ">>> Adding ZscalarRootCA to the certs"
	sudo apt install -y ca-certificates
	rm -f /usr/local/share/ca-certificates/ZscalerRootCA.crt
	sudo cp '/mnt/c/Users/JijiJames/OneDrive - C&R Software/Computer_Setup/zscalar/ZscalerRootCA.crt' /usr/local/share/ca-certificates
	sudo update-ca-certificates
fi


