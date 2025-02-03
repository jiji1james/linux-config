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
			sudo apt install -y ca-certificates
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
