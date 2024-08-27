#!/usr/bin/env zsh

# Set tab size to 4 
tabs 4

# History Options
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:logout:ls:dir:clear'

alias zsh-source='source $HOME/.zshrc'
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

alias idea="~/.jetbrains/idea/bin/idea > /dev/null 2>&1 &"

# Bash PS1 config
if [[ -f "$HOME/linux-config/git-prompt.sh" ]]; then
    source $HOME/linux-config/git-prompt.sh

    # Default from https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
    # This is copied as git-prompt.sh
    # PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

    # Colorized using https://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
    export PS1='\n\e[0;32m\W\e[m\e[0;33m$(__git_ps1 " (%s)")\e[m @ \e[0;36m$WSL_IP\e[m\n> '
fi
