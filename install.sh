#!/bin/sh

source "./progress.zsh"

function run_scripts {

    CURRENT_PERCENTAGE=$1

    DUMMY_CUMPUTING_DELAY=$(( ( RANDOM % 20 ) / 10 ))  # Replace by zero

    git clone https://github.com/zap-zsh/zap.git "$HOME/.local/share/zap" > /dev/null 2>&1
    mkdir -p "$HOME/.local/share/zap/plugins"

    # check if ZDOTDIR is set, and if it is, check if ZDOTDIR/.zshrc exists
    if [[ ! -z $ZDOTDIR ]] && [[ -f $ZDOTDIR/.zshrc ]]; then
        zshrc="$ZDOTDIR/.zshrc"
    else
        zshrc="$HOME/.zshrc"
    fi

    # shellcheck disable=SC2016
    if ! grep -q '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' "$zshrc"; then
        echo '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' >> "$zshrc"
    fi

    sleep $DUMMY_CUMPUTING_DELAY

    sleep $PROGRESS_DELAY

}

echo
progress 0; progress 100
echo
echo " Zapped"
