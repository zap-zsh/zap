#!/bin/sh

git clone https://github.com/zap-zsh/zap.git "$HOME/.local/share/zap"

# shellcheck disable=SC2016
echo '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' >> "$HOME/.zshrc"
