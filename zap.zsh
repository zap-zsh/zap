#!/bin/sh

export ZAP_DIR="$HOME/.local/share/zap"
export ZAP_PLUGIN_DIR="$ZAP_DIR/plugins"

plug() {
    plugin="$1"
    if [ -f "$plugin" ]; then
        source "$plugin"
    else
        local git_ref="$2"
        local plugin_name=$(echo "$plugin" | cut -d "/" -f 2)
        local plugin_dir="$ZAP_PLUGIN_DIR/$plugin_name"
        if [ ! -d "$plugin_dir" ]; then
            echo "🔌$plugin_name"
            git clone "https://github.com/${plugin}.git" "$plugin_dir" > /dev/null 2>&1
            if [ -n "$git_ref" ]; then
                git -C "$plugin_dir" checkout "$git_ref" > /dev/null 2>&1
            fi
            if [ $? -ne 0 ]; then
                echo "Failed to install $plugin_name"
                exit 1
            fi
            echo -e "\e[1A\e[K⚡$plugin_name"
        fi
        local full_path="$plugin_dir/$plugin$name"
        # shellcheck disable=SC1090
        [[ -f "$full_path.plugin.zsh" ]] && source "$full_path.plugin.zsh"
        [[ -f "$full_path.zsh" ]] && source "$full_path.zsh"
        [[ -f "$full_path.zsh-theme" ]] && source "$full_path.zsh-theme"
    fi
}

_pull() {
    echo "🔌$1"
    git pull > /dev/null 1>&1
    if [ $? -ne 0 ]; then
        echo "Failed to Update $1"
        exit 1
    fi
    echo -e "\e[1A\e[K⚡$1"
}

update() {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo ""
    echo "Plugin Name / (a) for All Plugins / (self) for Zap Itself: "
    read plugin
    pwd=$(pwd)
    echo ""
    if [[ $plugin == "a" ]]; then
        cd "$ZAP_PLUGIN_DIR"
        for plug in *; do
            cd $plug
            _pull $plug
            cd ..
        done
        cd $pwd
    elif [[ $plugin == "self" ]]; then
        cd "$ZAP_PLUGIN_DIR"
        _pull 'zap'
        cd $pwd
    else
        cd "$ZAP_PLUGIN_DIR/$plugin"
        _pull $plug
        cd $pwd
    fi
}

delete() {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo -n "Plugin Name: "
    read plugin
    cd "$ZAP_PLUGIN_DIR" && echo "Deleting $plugin ..." && rm -rf $plugin > /dev/null 2>&1 && cd - > /dev/null 2>&1 && echo "Deleted $plugin " || echo "Failed to delete : $plugin"
}

pause() {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo ""
    echo -n "Plugin Name or (a) to Update All: "
    read plugin
    if [[ $plugin == "a" ]]; then
        sed -i '/^plug/s/^/#/g' $ZDOTDIR/.zshrc
    else
        sed -i "/\/$plugin/s/^/#/g" $ZDOTDIR/.zshrc
    fi
}

unpause() {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo ""
    echo -n "Plugin Name or (a) to Update All: "
    read plugin
    if [[ $plugin == "a" ]]; then
        sed -i '/^#plug/s/^#//g' $ZDOTDIR/.zshrc
    else
        sed -i "/\/$plugin/s/^#//g" $ZDOTDIR/.zshrc
    fi
}

Help() {
    cat "$ZAP_DIR/doc.txt"
}

Version() {
    ref=$ZAP_DIR/.git/packed-refs
    tag=$(awk 'BEGIN { FS = "[ /]" } { print $3, $4 }' $ref | grep tags)
    ver=$(echo $tag | cut -d " " -f 2)
    echo "⚡Zap Version v$ver"
}

zap() {
    local command="$1"
    if [[ $command == "-v" ]] || [[ $command == "--version" ]]; then
        Version
        return
    else
        if [[ $command == "-h" ]] || [[ $command == "--help" ]]; then
            Help
            return
        else
            $command
            return
        fi
        echo "$command: command not found"
    fi
}

# vim: ft=bash ts=4 et
