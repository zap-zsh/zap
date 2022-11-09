#!/bin/sh

export ZAP_DIR="$HOME/.local/share/zap"
export ZAP_PLUGIN_DIR="$ZAP_DIR/plugins"

# Function to source files if they exist
function _try_source() {
    # shellcheck disable=SC1090
    [ -f "$1" ] && source "$1"
}

# For plugins
function zapplug() {
    local full_plugin_name="$1"
    local initialize_completion="$2"
    local plugin_name=$(echo "$full_plugin_name" | cut -d "/" -f 2)
    local plugin_dir="$ZAP_PLUGIN_DIR/$plugin_name"
    if [ ! -d "$plugin_dir" ]; then
      echo "Installing $plugin_name ..." && git clone "https://github.com/${full_plugin_name}.git" \
        "$plugin_dir" > /dev/null 2>&1 && echo " $plugin_name " || echo "Failed to install : $plugin_name"
    fi
    _try_source "$plugin_dir/$plugin_name.plugin.zsh"
    _try_source "$plugin_dir/$plugin_name.zsh"
    _try_source "$plugin_dir/$plugin_name.zsh-theme"
    local completion_file_path=$(ls $ZAP_PLUGIN_DIR/$plugin_name/_*)
    if [ -f "$completion_file_path" ]; then
        fpath+=$(ls $plugin_dir/_*)
        [ -f $ZAP_DIR/.zccompdump ] && $ZAP_DIR/.zccompdump
        fpath+="$(dirname $plugin_dir)"
        local completion_file="$(basename "$completion_file_path")"
        [ "$initialize_completion" = true ] && compinit "${completion_file:1}"
    fi
}
