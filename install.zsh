#!/usr/bin/env zsh

main() {

    local DATE=$(date +%Y-%m-%d)
    local ID=$(date +%s)
    local NEW_ZSHRC=".zshrc_${DATE}_${ID}"
    local ZAP_DIR="$HOME/.local/share/zap"
    local ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

    # Check if the current .zshrc file exists
    if [ -f "$ZSHRC" ]; then
        # Move the current .zshrc file to the new filename
        mv "$ZSHRC" "$HOME/$NEW_ZSHRC"
        echo "Moved .zshrc to $NEW_ZSHRC"
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

    git clone -b "${BRANCH:-master}" https://github.com/zap-zsh/zap.git "$ZAP_DIR" > /dev/null 2>&1 || { echo "❌ Failed to install Zap" && return 2 }

    echo " Zapped"
    # TODO: find a way for changes to take effect without user intervention
    echo "Run: source $ZSHRC for changes to take effect"
    echo "Or open a new terminal window"

    return 0
}

main $@

[[ $? -eq 0 ]] && exec zsh || return

# vim: ft=zsh ts=4 et
