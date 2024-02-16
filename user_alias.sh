#!/usr/bin/env zsh

# While the STANDARD width of a HORIZONTAL TAB is 5 SPACES, select key Linux
# shell authors erroneously set this width to 8.  Over time, a comfortable NORM
# of 4 spaces has been widely adopted by developers of most low-level languages
# (c, c++, etc.).  We will also adopt 4-space tab widths.
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

# Make the prompt useful
# export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '

# List directory names before file names like DOS
alias dir='ls -lahF --color=tty --time-style=long-iso --group-directories-first'

# Short-hand for a clean-screen directory listing
alias clsd='clear; dir'

# Setup tools
export CONTAINER_RUNTIME="docker"

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

