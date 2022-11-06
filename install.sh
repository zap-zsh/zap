#!/bin/sh

git clone https://github.com/zap-zsh/zap.git "$HOME/.local/share/zap"

mkdir "$HOME/.local/share/zap/plugins"

# shellcheck disable=SC2016
if ! grep -q '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' "$HOME/.zshrc"; then
    echo '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' >> "$HOME/.zshrc"
fi
