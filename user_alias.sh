#!/usr/bin/env zsh

alias zsh-source='source $HOME/.zshrc'
alias bash-source='source $HOME/.bashrc'

# Setup tools
export JAVA_HOME='/home/james/java/jdk8'
export TOOLS_HOME='/home/james/tools'
export ANT_HOME="$TOOLS_HOME/apache-ant-1.9.16"
export MVN_HOME="$TOOLS_HOME/apache-maven-3.9.3"
export CONTAINER_RUNTIME="podman"

# Add tools to path
export OLD_PATH="$ANT_HOME/bin:$MVN_HOME/bin:$PATH"
export PATH="$JAVA_HOME/bin:$OLD_PATH"

alias ecr-docker-login='aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 828586629811.dkr.ecr.us-east-1.amazonaws.com'
alias ecr-podman-login='aws ecr get-login-password --region us-east-1 | podman login --username AWS --password-stdin 828586629811.dkr.ecr.us-east-1.amazonaws.com'

alias wsl-ip-addr="ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
alias wsl-internet='echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf'
alias check-systemd="systemctl list-units --type=service"
alias dos2unix-recurse="find . -type f -exec dos2unix '{}' '+'"

export WSL_IP=$(wsl-ip-addr)
export HOST_IP=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf)

alias dm='cd $HOME/debtmanager'
alias cloud='cd $HOME/debtmanager/cloud'
alias onprem='cd $HOME/debtmanager/onprem'
alias tomcat='cd $HOME/debtmanager/dm-tomcat/apache-tomcat'
alias jboss='cd $HOME/debtmanager/dm-jboss/jboss-eap'

# AWS CLI
export AWS_ACCESS_KEY_ID="AKIA4B244TKZRBOHNE4L"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-east-1"

# Bash PS1 config
if [[ -f "$HOME/linux-config/git-prompt.sh" ]]; then
    source $HOME/linux-config/git-prompt.sh

    # Default from https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
    # This is copied as git-prompt.sh
    # PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

    # Colorized using https://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
    export PS1='\n\e[0;32m\W\e[m\e[0;33m$(__git_ps1 " (%s)")\e[m @ \e[0;36m$WSL_IP\e[m\n> '
fi

# Print a block of env values
printEnvironmentStatus

