# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

### ---- Autojump ----
[[ -s "/usr/share/autojump/autojump.sh" ]] && source "/usr/share/autojump/autojump.sh"

### ---- THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!! ----
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ---- Configure fzf ----
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

### ---- PLUGINS & THEMES ----
source ~/linux-config/user_functions.sh
source ~/linux-config/user_alias.sh
source ~/linux-config/user_fzf_functions.sh

### ---- Print a block of env values ----
printEnvironmentStatus