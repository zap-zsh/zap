#!/bin/sh

main() {
    local install_path="$HOME/.local/share/zap"

    # if install_path already exists
    if [ -d "$install_path" ]; then
        echo "zap is already installed in '$install_path'!"

        read -p "Reinstall zap? [y/n] " res

        if [ "$res" = "y" ]; then
            echo "Reinstalling..."
            rm -rf "$install_path"
        else
            exit 0
        fi
    fi

    git clone https://github.com/zap-zsh/zap.git "$install_path" > /dev/null 2>&1

    mkdir -p "$install_path/plugins"

    # check if ZDOTDIR is set, and if it is, check if ZDOTDIR/.zshrc exists
    if [ -n "$ZDOTDIR" ] && [ -f "$ZDOTDIR/.zshrc" ]; then
        zshrc="$ZDOTDIR/.zshrc"
    else
        zshrc="$HOME/.zshrc"
    fi
    touch "$zshrc"

    auto_source="[ -f \"${install_path}/zap.zsh\" ] && source \"${install_path}/zap.zsh\""

    # shellcheck disable=SC2016
    if ! grep -q "$auto_source" "$zshrc"; then
        echo "$auto_source" >> "$zshrc"
    fi

    echo " Zapped"
}

main

# vim: ft=bash ts=4 et
