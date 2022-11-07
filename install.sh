#!/bin/sh


function run_scripts {

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
}

echo
echo " Zapped"
