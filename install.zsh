#!/usr/bin/env zsh

main() {

    local HELP KEEP
    local BRANCH=(master)
    local OPTIONS_USAGE=(
        "USAGE:"
        "    install.zsh [options]"
        " "
        "OPTIONS:"
        "    -h, --help     Show this help message"
        "    -k, --keep     Don't override existing .zshrc"
        "    -b, --branch   Zap repository branch name"
    )

    echo "⚡ Zap - Installer\n"

    zmodload zsh/zutil
    zparseopts -D -K -- \
        {h,-help}=HELP \
        {k,-keep}=KEEP \
        {b,-branch}:=BRANCH ||
    return 1

    [[ -z "$HELP" ]] || { print -l $OPTIONS_USAGE && return }

    local BACKUP_SUFFIX="$(date +%Y-%m-%d)_$(date +%s)"
    local ZAP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zap"
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

    # Clone the Zap Repository branch
    git clone -b "$BRANCH[-1]" https://github.com/zap-zsh/zap.git "$ZAP_DIR" &> /dev/null || { echo "❌ Git is a dependency for zap. Please install git and try again." && return 2 }

    # Only modify .zshrc file if --keep flag not set
    if [[ -z "$KEEP" ]]; then
        # Check the .zshrc template exists
        if [ ! -f "$ZAP_DIR/templates/default-zshrc" ]; then
            echo "Template .zshrc file was not found in Zap installation"
            return 2
        fi

        # Check if the current .zshrc file exists
        if [ -f "$ZSHRC" ]; then
            # Move the current .zshrc file to the new filename
            mv "$ZSHRC" "${ZSHRC}_${BACKUP_SUFFIX}"
            echo "Moved .zshrc to .zshrc_$BACKUP_SUFFIX"
        else
            echo "No .zshrc file found, creating a new one..."
            touch "$ZSHRC"
        fi

        # Write out the .zshrc template to the .zshrc
        cat "$ZAP_DIR/templates/default-zshrc" >> "$ZSHRC"
    fi

    echo " Zapped"
    echo "Find more plugins at http://zapzsh.org"

    return 0
}

main $@

[[ $? -eq 0 ]] && source "${ZDOTDIR:-$HOME}/.zshrc" || return

# vim: ft=zsh ts=4 et
