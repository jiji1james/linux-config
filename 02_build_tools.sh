#!/usr/bin/env bash
cwd=$(pwd)

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

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf ./aws ./awscliv2.zip

# Install SDKMAN
curl -s "https://get.sdkman.io" | bash
source $HOME/.sdkman/bin/sdkman-init.sh

# Function to find and install a specific Java version
sdkman_install_java() {
    if [ -z "$1" ]; then
        echo "Usage: sdkman_install_java <version>"
        echo "Available versions: 8, 17, 21, etc."
        return 1
    fi
    correttoJavaVersion=$(sdk list java | grep 8.*amzn | awk -F'|' '{ gsub(/^ +| +$/, "", $NF); print $NF }' | sort -r | head -n 1)
    echo ">>> Installing Corretto Java Version: $correttoJavaVersion"
    sdk install java "$correttoJavaVersion"
}

sdkman_install_java 8
sdkman_install_java 17
sdkman_install_java 21

sdk install ant 1.9.15
sdk install maven 3.9.6
sdk install gradle
