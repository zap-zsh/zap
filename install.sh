#!/bin/sh

main() {
    branch="master"
    if test "$1" = "--branch"; then
        branch="$2"
    fi

    git clone -b "$branch" https://github.com/zap-zsh/zap.git "$HOME/.local/share/zap" > /dev/null 2>&1
    mkdir -p "$HOME/.local/share/zap/plugins"

    # check if ZDOTDIR is set, and if it is, check if ZDOTDIR/.zshrc exists
    zshrc="${ZDOTDIR:-$HOME}/.zshrc"
    touch "$zshrc"

    # shellcheck disable=SC2016
    if ! grep -q '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' "$zshrc"; then
        echo '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' >> "$zshrc"
    fi
}

main "$@"
echo " Zapped"

# vim: ft=bash ts=4 et
