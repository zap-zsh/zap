#!/usr/bin/env zsh

main() {
    local ZAP_DIR="$HOME/.local/share/zap"
    local ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
    [[ $1 == "--branch" || $1 == "-b" && -n $2 ]] && local BRANCH="$2"

    git clone -b "${BRANCH:-master}" https://github.com/zap-zsh/zap.git "$ZAP_DIR" > /dev/null 2>&1 || echo "❌ Failed to install Zap" && return 2
    mkdir -p "$ZAP_DIR/plugins"

# @formatter:off
	if ! grep -q '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' "$ZSHRC"; then
		sed -i.old '1 i\
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' "$ZSHRC"
	fi
# @formatter:on
    echo " Zapped"
    return 0
}

main $@

# vim: ft=zsh ts=4 et