#!/bin/sh

export ZAP_DIR="$HOME/.local/share/zap"
export ZAP_PLUGIN_DIR="$ZAP_DIR/plugins"

# Function to source files if they exist
function zapsource() {
    # shellcheck disable=SC1090
    [ -f "$1" ] && source "$1"
}

# For plugins
function zapplug() {
    local full_plugin_name="$1"
    local plugin_name=$(echo "$full_plugin_name" | cut -d "/" -f 2)
    if [ ! -d "$ZAP_PLUGIN_DIR/$plugin_name" ]; then
      echo "Installing $plugin_name ..." && git clone "https://github.com/${full_plugin_name}.git" \
        "$ZAP_PLUGIN_DIR/$plugin_name" > /dev/null 2>&1 && echo " $plugin_name " || echo "Failed to install : $plugin_name"
    fi
    zapsource "$ZAP_PLUGIN_DIR/$plugin_name/$plugin_name.plugin.zsh" || \
    zapsource "$ZAP_PLUGIN_DIR/$plugin_name/$plugin_name.zsh" || \
    zapsource "$ZAP_PLUGIN_DIR/$plugin_name/$plugin_name.zsh-theme"
}

# For completions
function zapcmp() {
    local full_plugin_name="$1"
    local initialize_completion="$2"
    local plugin_name=$(echo "$full_plugin_name" | cut -d "/" -f 2)
    if [ ! -d "$ZAP_PLUGIN_DIR/$plugin_name" ]; then
        git clone "https://github.com/${full_plugin_name}.git" "$ZAP_PLUGIN_DIR/$plugin_name" \
          > /dev/null 2>&1 && echo " $plugin_name " || echo "Failed to install : $plugin_name"
        fpath+=$(ls $ZAP_PLUGIN_DIR/$plugin_name/_*)
        [ -f $ZAP_DIR/.zccompdump ] && $ZAP_DIR/.zccompdump
    fi
    local completion_file_path=$(ls $ZAP_PLUGIN_DIR/$plugin_name/_*)
    fpath+="$(dirname "${completion_file_path}")"
    zapsource $ZAP_PLUGIN_DIR/$plugin_name/$plugin_name.plugin.zsh
    local completion_file="$(basename "${completion_file_path}")"
    [ "$initialize_completion" = true ] && compinit "${completion_file:1}"
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
  cat "./doc.txt"
}

function zap() {
    local command="$1"
    [[ "$command" == "-h" ]] && Help || $command || echo "$command: command not found"
}

