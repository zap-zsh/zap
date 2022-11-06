#!/bin/sh

# Function to source files if they exist
function zapsource() {
    [ -f "$1" ] && source "$1"
}

# For plugins
function zapplug() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ ! -d "$HOME/.local/share/zap/plugins/$PLUGIN_NAME" ]; then
      echo "Installing $PLUGIN_NAME ..." && git clone "https://github.com/$1.git" "$HOME/.local/share/zap/plugins/$PLUGIN_NAME" > /dev/null 2>&1 && echo "  $PLUGIN_NAME " || echo "Failed to install : $PLUGIN_NAME"
    fi
    zapsource "$HOME/.local/share/zap/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
    zapsource "$HOME/.local/share/zap/plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
}

# For completions
function zapcmp() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ ! -d "$HOME/.local/share/zap/plugins/$PLUGIN_NAME" ]; then
        git clone "https://github.com/$1.git" "$HOME/.local/share/zap/plugins/$PLUGIN_NAME" > /dev/null 2>&1 && echo "  $PLUGIN_NAME " || echo "Failed to install : $PLUGIN_NAME"
        fpath+=$(ls $HOME/.local/share/zap/plugins/$PLUGIN_NAME/_*)
        [ -f $HOME/.local/share/zap/.zccompdump ] && $HOME/.local/share/zap/.zccompdump
    fi
    completion_file_path=$(ls $HOME/.local/share/zap/plugins/$PLUGIN_NAME/_*)
    fpath+="$(dirname "${completion_file_path}")"
    zapsource $HOME/.local/share/zap/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh
    completion_file="$(basename "${completion_file_path}")"
    [ "$2" = true ] && compinit "${completion_file:1}"
}
