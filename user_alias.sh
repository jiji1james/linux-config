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

# Liven up the console for common commands
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'
alias ll='ls -l --color=auto'
alias la='ls -A --color=auto'

# List directory names before file names like DOS
alias dir='ls -lahF --color=tty --time-style=long-iso --group-directories-first'

# Setup tools
export CONTAINER_RUNTIME="docker"

alias wsl-ip-addr="ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
alias wsl-internet='echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf'
alias check-systemd="systemctl list-units --type=service"
alias dos2unix-recurse="find . -type f -exec dos2unix '{}' '+'"

export WSL_IP=$(wsl-ip-addr)
export HOST_IP=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf)

alias dm='cd $DM_HOME'
alias cloud='cd $DM_HOME/cloud'
alias onprem='cd $DM_HOME/onprem'
alias tomcat='cd $TOMCAT_HOME'
alias jboss='cd $JBOSS_HOME'

alias ideau="~/.jetbrains/ideau/bin/idea > /dev/null 2>&1 &"
alias ideac="~/.jetbrains/ideac/bin/idea > /dev/null 2>&1 &"
