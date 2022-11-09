#!/bin/sh

export ZAP_DIR="$HOME/.local/share/zap"
export ZAP_PLUGIN_DIR="$ZAP_DIR/plugins"

function _try_source() {
    # shellcheck disable=SC1090
    [ -f "$1" ] && source "$1"
}

function zapplug() {
    local full_plugin_name="$1"
    local initialize_completion="$2"
    local plugin_name=$(echo "$full_plugin_name" | cut -d "/" -f 2)
    local plugin_dir="$ZAP_PLUGIN_DIR/$plugin_name"
    if [ ! -d "$plugin_dir" ]; then
        echo "🔌$plugin_name"
        git clone "https://github.com/${full_plugin_name}.git" "$plugin_dir" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Failed to install $plugin_name"
            exit 1
        fi
        echo -e "\e[1A\e[K⚡$plugin_name"
    fi
    _try_source "$plugin_dir/$plugin_name.plugin.zsh"
    _try_source "$plugin_dir/$plugin_name.zsh"
    _try_source "$plugin_dir/$plugin_name.zsh-theme"
    local completion_file_path=$(find "$plugin_dir" -maxdepth 1 -type f -name "_*" | head -1)
    if [ -f "$completion_file_path" ]; then
        fpath+=$("$completion_file_path")
        [ -f "$ZAP_DIR/.zccompdump" ] && "$ZAP_DIR/.zccompdump"
        fpath+="$(dirname "$plugin_dir")"
        local completion_file="$(basename "$completion_file_path")"
        [ "$initialize_completion" = true ] && compinit "${completion_file:1}"
    fi
}
