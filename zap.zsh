#!/bin/sh
# shellcheck disable=SC1090

fpath=(~/.local/share/zap/completion $fpath)
rm -rf "$HOME/.local/share/zap/installed_plugins"
export ZAP_DIR="$HOME/.local/share/zap"
export ZAP_PLUGIN_DIR="$ZAP_DIR/plugins"
if [ -z "$ZDOTDIR" ]; then
    export ZAP_ZSHRC="$HOME/.zshrc" # ~/.zshrc
else
    export ZAP_ZSHRC="$ZDOTDIR/.zshrc"
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
        local plugin_name=$(echo "$plugin" | awk -F / '{print $NF}')
        plugin_name="${plugin_name/.git/}"
        local plugin_dir="$ZAP_PLUGIN_DIR/$plugin_name"
        if [ ! -d "$plugin_dir" ]; then
            echo "🔌$plugin_name"
            git clone $full_plugin_name --depth 1 "$plugin_dir" > /dev/null 2>&1
            if [ $? -ne 0 ]; then
                git clone "https://github.com/$full_plugin_name.git" --depth 1 "$plugin_dir" > /dev/null 2>&1
                if [ $? -ne 0 ]; then echo "Failed to clone $plugin_name" && return 1; fi
            fi
            if [ -n "$git_ref" ]; then
                git -C "$plugin_dir" checkout "$git_ref" > /dev/null 2>&1
                if [ $? -ne 0 ]; then echo "Failed to checkout $git_ref" && return 1; fi
            fi
            echo -e "\e[1A\e[K⚡$plugin_name"
        fi
        _try_source "$plugin_dir/$plugin_name.plugin.zsh"
        _try_source "$plugin_dir/$plugin_name.zsh"
        _try_source "$plugin_dir/$plugin_name.zsh-theme"
    fi
    if [[ -n $full_plugin_name ]]; then
        echo "$full_plugin_name" >> "$ZAP_DIR/installed_plugins"
    fi
}

_pull() {
    echo "🔌 $1"
    git pull > /dev/null 2>&1
    if [ $? -ne 0 ]; then echo "Failed to update $1" && return 1; fi
    echo -e "\e[1A\e[K⚡ $1"
}

_zap_clean() {
    unused_plugins=()
    for i in "$HOME"/.local/share/zap/plugins/*; do
        local plugin_name=$(basename "$i")
        if ! grep -q "$plugin_name" "$HOME/.local/share/zap/installed_plugins"; then
            unused_plugins+=("$plugin_name")
        fi
    done
    if [ ${#unused_plugins[@]} -eq 0 ]; then
        echo "✅ Nothing to remove"
    else
        for p in ${unused_plugins[@]}; do
            echo -n "Remove: $p? (y/n): "
            read answer
            if [[ $answer == "y" ]]; then
                rm -rf "$HOME/.local/share/zap/plugins/$p"
                echo "removed: $p"
            fi
        done
    fi
}

_zap_update() {
    plugins=$(cat "$HOME/.local/share/zap/installed_plugins" | awk 'BEGIN { FS = "\n" } { print " " int((NR)) echo "  🔌 " $1 }')
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
        selected_number=($(echo $plugin | awk -F '[[:space:]]' '{print $0}'))
        sorted=($(printf '%s\n' "${selected_number[@]}"|sort -u))
        for item in $sorted;do
            for plug in $plugins; do
                selected=$(echo $plug | grep -E "^ ${item##*( )}" | awk -F / '{print $NF}')
                selected="${selected/.git/}"
                if [[ -n $selected ]]; then
                    if [[ -d "$ZAP_PLUGIN_DIR/$selected" ]];then
                        cd "$ZAP_PLUGIN_DIR/$selected"
                        _pull $selected
                        cd - > /dev/null 2>&1
                    fi
                else
                    echo "  ${item##*( )} is not a valid option!"
                fi
            done
        done
    fi
    if [[ $ZAP_CLEAN_ON_UPDATE == true ]]; then
        _zap_clean
    fi
}

_zap_help() {
    cat "$ZAP_DIR/doc.txt"
}

_zap_version() {
    ref=$ZAP_DIR/.git/packed-refs
    tag=$(awk 'BEGIN { FS = "[ /]" } { print $3, $4 }' $ref | grep tags | tail -1)
    ver=$(echo $tag | cut -d " " -f 2)
    echo "⚡Zap Version v$ver"
}

typeset -A opts
opts=(
    -h "_zap_help"
    --help "_zap_help"
    -u "_zap_update"
    --update "_zap_update"
    -c "_zap_clean"
    --clean "_zap_clean"
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
