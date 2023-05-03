#!/usr/bin/env zsh

main() {

    local BACKUP_SUFFIX="$(date +%Y-%m-%d)_$(date +%s)"
    local ZAP_DIR="$HOME/.local/share/zap"
    local ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

    # check if ZAP_DIR already exists
    [[ -d "$ZAP_DIR" ]] && {
        echo "Zap is already installed in '$ZAP_DIR'!"
        read -q "res?Reinstall Zap? [y/N] "
        echo ""
        [[ $res == "n" ]] && {
            echo "❕ skipped!"
            return
        }
        echo "Reinstalling Zap..."
        rm -rf "$ZAP_DIR"
    }

    # Check if the current .zshrc file exists
    if [ -f "$ZSHRC" ]; then
        # Move the current .zshrc file to the new filename
        mv "$ZSHRC" "${ZSHRC}_${BACKUP_SUFFIX}"
        echo "Moved .zshrc to .zshrc_$BACKUP_SUFFIX"
    else
        echo "No .zshrc file found, creating a new one..."
    fi

    # Check if .zshrc file exists, create it if not
    if [ ! -f "$ZSHRC" ]; then
        touch "$ZSHRC"
    fi

    echo "# Created by Zap installer" >> "$ZSHRC"
    echo '[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"' >> "$ZSHRC"
    echo 'plug "zsh-users/zsh-autosuggestions"' >> "$ZSHRC"
    echo 'plug "zap-zsh/supercharge"' >> "$ZSHRC"
    echo 'plug "zap-zsh/zap-prompt"' >> "$ZSHRC"
    echo 'plug "zsh-users/zsh-syntax-highlighting"' >> "$ZSHRC"

    [[ $1 == "--branch" || $1 == "-b" && -n $2 ]] && local BRANCH="$2"

    git clone --depth 1 -b "${BRANCH:-master}" https://github.com/zap-zsh/zap.git "$ZAP_DIR" > /dev/null 2>&1 || { echo "❌ Failed to install Zap" && return 2 }

    echo " Zapped"
    echo "Find more plugins at http://zapzsh.org"

    return 0
}

main $@

[[ $? -eq 0 ]] && source "${ZDOTDIR:-$HOME}/.zshrc" || return

# vim: ft=zsh ts=4 et
