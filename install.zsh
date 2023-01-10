#!/usr/bin/env zsh

main() {
    local ZAP_DIR="$HOME/.local/share/zap"
    local ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
    [[ $1 == "--branch" || $1 == "-b" ]] && local BRANCH="$2"

    git clone -b "${BRANCH:-"master"}" https://github.com/zap-zsh/zap.git "$ZAP_DIR" > /dev/null 2>&1 || return
    mkdir -p "$ZAP_DIR/plugins"

    if ! grep -q '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' "$ZSHRC"; then
        sed -i.old '1 i\
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' "$ZSHRC"
    fi
    echo " Zapped"
    return 0
}

main $@

# vim: ft=zsh ts=4 et
