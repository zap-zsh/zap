#!/bin/sh

# Function to source files if they exist
function zapsource() {
    [ -f "$1" ] && source "$1"
}

function zapplug() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$HOME/.local/share/zap/plugins/$PLUGIN_NAME" ]; then 
        # For plugins
        zapsource "$HOME/.local/share/zap/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zapsource "$HOME/.local/share/zap/plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$HOME/.local/share/zap/plugins/$PLUGIN_NAME"
    fi
}

function zapcmp() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$HOME/.local/share/zap/plugins/$PLUGIN_NAME" ]; then 
        # For completions
		completion_file_path=$(ls $HOME/.local/share/zap/plugins/$PLUGIN_NAME/_*)
		fpath+="$(dirname "${completion_file_path}")"
        zapsource "$HOME/.local/share/zap/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    else
        git clone "https://github.com/$1.git" "$HOME/.local/share/zap/plugins/$PLUGIN_NAME"
		fpath+=$(ls $HOME/.local/share/zap/plugins/$PLUGIN_NAME/_*)
        [ -f "$HOME/.local/share/zap/.zccompdump ] && $HOME/.local/share/zap/.zccompdump"
    fi
	completion_file="$(basename "${completion_file_path}")"
	if [ "$2" = true ] && compinit "${completion_file:1}"
}
