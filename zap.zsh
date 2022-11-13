#!/bin/sh
# shellcheck disable=SC1090

export ZAP_DIR="$HOME/.local/share/zap"
export ZAP_PLUGIN_DIR="$ZAP_DIR/plugins"
if [ -z "$ZDOTDIR" ]; then
    export ZAP_ZSHRC=$HOME/.zshrc # ~/.zshrc
else
    export ZAP_ZSHRC=$ZDOTDIR/.zshrc
fi

_try_source() {
    # shellcheck disable=SC1090
    [ -f "$1" ] && source "$1"
}

plug() {
    plugin="$1"
    if [ -f "$plugin" ]; then
        source "$plugin"
    else
        local full_plugin_name="$1"
        local git_ref="$2"
        local plugin_name=$(echo "$full_plugin_name" | cut -d "/" -f 2)
        local plugin_dir="$ZAP_PLUGIN_DIR/$plugin_name"
        if [ ! -d "$plugin_dir" ]; then
            echo "🔌$plugin_name"
            git clone "https://github.com/${full_plugin_name}.git" "$plugin_dir" > /dev/null 2>&1
            if [ -n "$git_ref" ]; then
                git -C "$plugin_dir" checkout "$git_ref" > /dev/null 2>&1
            fi
            if [ $? -ne 0 ]; then
                echo "Failed to install $plugin_name"
                exit 1
            fi
            echo -e "\e[1A\e[K⚡$plugin_name"
        fi
        _try_source "$plugin_dir/$plugin_name.plugin.zsh"
        _try_source "$plugin_dir/$plugin_name.zsh"
        _try_source "$plugin_dir/$plugin_name.zsh-theme"
    fi
}

_pull() {
    echo "🔌$1"
    git pull > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Failed to Update $1"
        exit 1
    fi
    echo -e "\e[1A\e[K⚡$1"
}

_zap_update() {
    plugins=$(awk 'BEGIN { FS = "[ plug]" } { print }' $ZAP_ZSHRC | grep -E '^plug "' | awk 'BEGIN { FS = "[ \"]" } { print " " int((NR)) echo "  🔌 " $3 }')
    echo -e " 0  ⚡ Zap"
    echo "$plugins \n"
    echo -n "🔌 Plugin Number | (a) All Plugins | (0) ⚡ Zap Itself: "
    read plugin
    pwd=$(pwd)
    echo ""
    if [[ $plugin == "a" ]]; then
        cd "$ZAP_PLUGIN_DIR"
        for plug in *; do
            cd $plug
            _pull $plug
            cd "$ZAP_PLUGIN_DIR"
        done
        cd $pwd > /dev/null 2>&1
    elif [[ $plugin == "0" ]]; then
        cd "$ZAP_DIR"
        _pull 'zap'
        cd $pwd
    else
        for plug in $plugins; do
            selected=$(echo $plug | grep -E "^ $plugin" | awk 'BEGIN { FS = "[ /]" } { print $6 }')
            cd "$ZAP_PLUGIN_DIR/$selected"
            _pull $selected
            cd - > /dev/null 2>&1
        done
    fi
}

_zap_remove() {
    plugins=$(awk 'BEGIN { FS = "[ plug]" } { print }' $ZAP_ZSHRC | grep -E '^plug "' | awk 'BEGIN { FS = "[ \"]" } { print " " int((NR)) echo "  🔌 " $3 }')
    if [ -z $plugins ]; then
        echo "There are no plugins"
        return 0
    fi
    echo "$plugins \n"
    echo -n "🔌 Plugin Number: "
    read plugin
    pwd=$(pwd)
    for plug in $plugins; do
        usr=$(echo $plug | grep -E "^ $plugin" | awk 'BEGIN { FS = "[ /]" } { print $5 }')
        plg=$(echo $plug | grep -E "^ $plugin" | awk 'BEGIN { FS = "[ /]" } { print $6 }')
        sed -i'.backup' "/$usr\/$plg/s/^/#\ /g" $ZAP_ZSHRC
        rm -rf $ZAP_PLUGIN_DIR/$plg && echo "Removed $usr's $plg plugin" || echo "Failed to Remove $usr's $plg plugin \n"
    done
}

_zap_deactivate() {
    plugins=$(awk 'BEGIN { FS = "[ plug]" } { print }' $ZAP_ZSHRC | grep -E '^plug "' | awk 'BEGIN { FS = "[ \"]" } { print " " int((NR)) echo "  🔌 " $3 }')
    if [ -z $plugins ]; then
        echo "There is no plugin to deactivate"
        return 0
    fi
    echo "$plugins \n"
    echo -n "🔌 Plugin Number | (a) All Plugins: "
    read plugin
    echo ""
    if [[ $plugin == "a" ]]; then
        sed -i'.backup' '/^plug/s/^/#\ /g' $ZAP_ZSHRC && echo "Deactivated all active plugins" || echo "Failed to Deactivate all active plugins \n"
    else
        for plug in $plugins; do
            usr=$(echo $plug | grep -E "^ $plugin" | awk 'BEGIN { FS = "[ /]" } { print $5 }')
            plg=$(echo $plug | grep -E "^ $plugin" | awk 'BEGIN { FS = "[ /]" } { print $6 }')
            sed -i'.backup' "/$usr\/$plg/s/^/#\ /g" $ZAP_ZSHRC && echo "Deactivated $usr's $plg plugin" || echo "Failed to Deactivate $usr's $plg plugin \n"
        done
    fi
}

_zap_activate() {
    plugins=$(awk 'BEGIN { FS = "[ plug]" } { print }' $ZAP_ZSHRC | grep -E '^# plug "' | awk 'BEGIN { FS = "[ \"]" } { print " " int((NR)) echo "  🔌 " $4 }')
    if [ -z $plugins ]; then
        echo "All plugins are active"
        return 0
    fi
    echo "$plugins \n"
    echo -n "🔌 Plugin Number | (a) Plug All: "
    read plugin
    echo ""
    if [[ $plugin == "a" ]]; then
        sed -i'.backup' '/^#\ plug/s/^#\ //g' $ZAP_ZSHRC && echo "Activated all inactive plugins" || echo "Failed to Activate all inactive plugins \n"
    else
        for plug in $plugins; do
            usr=$(echo $plug | grep -E "^ $plugin" | awk 'BEGIN { FS = "[ /]" } { print $5 }')
            plg=$(echo $plug | grep -E "^ $plugin" | awk 'BEGIN { FS = "[ /]" } { print $6 }')
            sed -i'.backup' "/$usr\/$plg/s/^#\ //g" $ZAP_ZSHRC && echo "Activated $usr's $plg plugin" || echo "Failed to Activate $usr's $plg plugin \n"
        done
    fi
}

_zap_help() {
    cat "$ZAP_DIR/doc.txt"
}

_zap_version() {
    ref=$ZAP_DIR/.git/packed-refs
    tag=$(awk 'BEGIN { FS = "[ /]" } { print $3, $4 }' $ref | grep tags)
    ver=$(echo $tag | cut -d " " -f 2)
    echo "\n ⚡Zap Version v$ver \n"
}

typeset -A opts
opts=(
    -a "_zap_activate"
    --activate "_zap_activate"
    -d "_zap_deactivate"
    --deactivate "_zap_deactivate"
    -h "_zap_help"
    --help "_zap_help"
    -r "_zap_remove"
    --remove "_zap_remove"
    -u "_zap_update"
    --update "_zap_update"
    -v "_zap_version"
    --version "_zap_version"
)

zap() {
    emulate -L zsh
    if [[ -z "$opts[$1]" ]]; then
        _zap_help
        return 1
    fi
    opt="${opts[$1]}"
    $opt
}

# vim: ft=bash ts=4 et
