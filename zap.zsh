#!/bin/sh

# Function to source files if they exist
function zsh_add_file() {
    [ -f "$HOME/.config/zsh/$1" ] && source "$HOME/.config/zsh/$1"
}

function zapadd() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$HOME/.config/zsh/plugins/$PLUGIN_NAME" ]; then 
        # For plugins
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$HOME/.config/zsh/plugins/$PLUGIN_NAME"
    fi
}

function zapcmp() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "$HOME/.config/zsh/plugins/$PLUGIN_NAME" ]; then 
        # For completions
		completion_file_path=$(ls $HOME/.config/zsh/plugins/$PLUGIN_NAME/_*)
		fpath+="$(dirname "${completion_file_path}")"
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    else
        git clone "https://github.com/$1.git" "$HOME/.config/zsh/plugins/$PLUGIN_NAME"
		fpath+=$(ls $HOME/.config/zsh/plugins/$PLUGIN_NAME/_*)
        [ -f $HOME/.config/zsh/.zccompdump ] && $HOME/.config/zsh/.zccompdump
    fi
	completion_file="$(basename "${completion_file_path}")"
	if [ "$2" = true ] && compinit "${completion_file:1}"
}
