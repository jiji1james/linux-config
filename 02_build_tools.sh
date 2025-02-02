#!/usr/bin/env bash
cwd=$(pwd)

# Install AWS CLI
brew install awscli

# Install SDKMAN
curl -s "https://get.sdkman.io" | bash
source $HOME/.sdkman/bin/sdkman-init.sh

sdk install java 8.0.442-amzn
sdk install java 17.0.14-amzn
sdk install java 21.0.6-amzn

sdk install ant 1.9.15
sdk install maven 3.9.6
sdk install gradle

# Install diffsofancy
brew install diff-so-fancy
