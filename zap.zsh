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

update () {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo -n "Plugin Name or (a) to Update All: ";
    read plugin;
    pwd=$(pwd)
    if [ $plugin="a" ]; then
      cd "$ZAP_PLUGIN_DIR" && for plug in *; do cd $plug && echo "Updating $plug ..." && git pull > /dev/null 1>&1 && echo "Updated $plug" && cd ..; done
      cd $pwd
    else
      cd "$ZAP_PLUGIN_DIR/$plugin" && echo "Updating $plugin ..." && git pull > /dev/null 2>&1 && cd - > /dev/null 2>&1 && echo "Updated $plugin " || echo "Failed to update : $plugin"
    fi
}

delete () {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo -n "Plugin Name: ";
    read plugin;
    cd "$ZAP_PLUGIN_DIR" && echo "Deleting $plugin ..." && rm -rf $plugin > /dev/null 2>&1 && cd - > /dev/null 2>&1 && echo "Deleted $plugin " || echo "Failed to delete : $plugin"
}

# pause target
pause() {
    sed -i '/^zapplug/s/^/#/g' ~/.zshrc
}

# unpause target
unpause() {
    sed -i '/^#zapplug/s/^#//g' ~/.zshrc
}

Help () {
  cat "$ZAP_DIR/doc.txt"
}

function zap() {
    local command="$1"
    [[ "$command" == "-h" ]] && Help || $command || echo "$command: command not found"
}

