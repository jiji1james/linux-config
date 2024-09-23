#!/usr/bin/env bash
cwd=$(pwd)

# Install AWS CLI
echo ""
echo ">>>> Installing AWS CLI Version 2"
cd $HOME
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf $HOME/aws
rm -f awscliv2.zip

# Install SDKMAN
curl -s "https://get.sdkman.io" | bash
source $HOME/.sdkman/bin/sdkman-init.sh

sdk install java 8.0.422-amzn
sdk install java 17.0.11-amzn
sdk install java 21.0.4-amzn

sdk install ant 1.9.15
sdk install maven 3.9.6
