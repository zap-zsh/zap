#!/bin/sh

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

update() {
    plugins=$(awk 'BEGIN { FS = "[ plug]" } { print }' $ZAP_ZSHRC | grep -E 'plug "' | awk 'BEGIN { FS = "[ \"]" } { print " " int((NR)) echo "  🔌 " $3 }')
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
            selected=$(echo $plug | grep $plugin | awk 'BEGIN { FS = "[ /]" } { print $6 }')
            cd "$ZAP_PLUGIN_DIR/$selected"
            _pull $selected
            cd - > /dev/null 2>&1
        done
    fi
}

remove() {
    plugins=$(awk 'BEGIN { FS = "[ plug]" } { print }' $ZAP_ZSHRC | grep -E 'plug "' | awk 'BEGIN { FS = "[ \"]" } { print " " int((NR)) echo "  🔌 " $3 }')
    echo "$plugins \n"
    echo -n "🔌 Plugin Number: "
    read plugin
    pwd=$(pwd)
    for plug in $plugins; do
        usr=$(echo $plug | grep $plugin | awk 'BEGIN { FS = "[ /]" } { print $5 }')
        plg=$(echo $plug | grep $plugin | awk 'BEGIN { FS = "[ /]" } { print $6 }')
        sed -i'.backup' "/$usr\/$plg/s/^/#/g" $ZAP_ZSHRC
        rm -rf $ZAP_PLUGIN_DIR/$plg && echo "Deleted $plg" || echo "Failed to Delete $plg"
    done
}

deactivate() {
    plugins=$(awk 'BEGIN { FS = "[ plug]" } { print }' $ZAP_ZSHRC | grep -E '^plug "' | awk 'BEGIN { FS = "[ \"]" } { print " " int((NR)) echo "  🔌 " $3 }')
    echo "$plugins \n"
    echo -n "🔌 Plugin Number | (a) All Plugins: "
    read plugin
    echo ""
    if [[ $plugin == "a" ]]; then
        sed -i'.backup' '/^plug/s/^/#/g' $ZAP_ZSHRC
    else
        for plug in $plugins; do
            usr=$(echo $plug | grep $plugin | awk 'BEGIN { FS = "[ /]" } { print $5 }')
            plg=$(echo $plug | grep $plugin | awk 'BEGIN { FS = "[ /]" } { print $6 }')
            sed -i'.backup' "/$usr\/$plg/s/^/#/g" $ZAP_ZSHRC
        done
    fi
}

activate() {
    plugins=$(awk 'BEGIN { FS = "[ plug]" } { print }' $ZAP_ZSHRC | grep -E '^#plug "' | awk 'BEGIN { FS = "[ \"]" } { print " " int((NR)) echo "  🔌 " $3 }')
    echo "$plugins \n"
    echo -n "🔌 Plugin Number | (a) Plug All: "
    read plugin
    echo ""
    if [[ $plugin == "a" ]]; then
        sed -i'.backup' '/^#plug/s/^#//g' $ZAP_ZSHRC
    else
        for plug in $plugins; do
            usr=$(echo $plug | grep $plugin | awk 'BEGIN { FS = "[ /]" } { print $5 }')
            plg=$(echo $plug | grep $plugin | awk 'BEGIN { FS = "[ /]" } { print $6 }')
            sed -i'.backup' "/$usr\/$plg/s/^#//g" $ZAP_ZSHRC
        done
    fi
}

help() {
    cat "$ZAP_DIR/doc.txt"
}

version() {
    ref=$ZAP_DIR/.git/packed-refs
    tag=$(awk 'BEGIN { FS = "[ /]" } { print $3, $4 }' $ref | grep tags)
    ver=$(echo $tag | cut -d " " -f 2)
    echo "\n ⚡Zap Version v$ver \n"
}

typeset -A opts
opts=(
    -a "activate"
    --activate "activate"
    -d "deactivate"
    --deactivate "deactivate"
    -h "help"
    --help "help"
    -r "remove"
    --remove "remove"
    -u "update"
    --update "update"
    -v "version"
    --version "version"
)

zap() {
    emulate -L zsh
    if [[ -z "$opts[$1]" ]]; then
        echo "$1: invalid option"
        return 1
    else
        opt="${opts[$1]}"
        $opt
    fi
}

# vim: ft=bash ts=4 et
