#!/usr/bin/env zsh

# Set tab size to 4 
tabs 4

alias zsh-source='exec zsh'
alias bash-source='source $HOME/.bashrc'

# Default to human readable figures for common file-size reporting commands
alias df='df -h'
alias du='du -h'

# Protect against accidental, all-too-easy file stomping
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ls aliases using eza
alias ls='eza --icons -G -F -H --group-directories-first --git'
alias ll='eza --icons -a -l -F -H --group-directories-first --git'
alias lt='eza -TL 2'

# Liven up the console for common commands
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Setup tools
export CONTAINER_RUNTIME="docker"

alias wsl-ip-addr="ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
alias wsl-internet='echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf'
alias check-systemd="systemctl list-units --type=service"
alias dos2unix-recurse="find . -type f -exec dos2unix '{}' '+'"

export HOST_IP=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf)

export CODE_SIGN_TOOL_HOME="$HOME/tools/CodeSignTool-v1.3.2-linux"
export PATH="$CODE_SIGN_TOOL_HOME:$PATH"

alias dm='cd $DM_HOME'
alias cloud='cd $DM_HOME/cloud'
alias onprem='cd $DM_HOME/onprem'
alias tomcat='cd $TOMCAT_HOME'
alias jboss='cd $JBOSS_HOME'

alias toolbox="~/.jetbrains/jetbrains-toolbox/jetbrains-toolbox > /dev/null 2>&1 &"
# alias ideac="~/.local/share/JetBrains/Toolbox/apps/intellij-idea-community-edition/bin/idea > /dev/null 2>&1 &"
# alias ideau="~/.jetbrains/ideau/bin/idea > /dev/null 2>&1 &"
alias ideac="~/.jetbrains/ideac/bin/idea > /dev/null 2>&1 &"

