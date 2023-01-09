#!/usr/bin/env zsh
# shellcheck disable=SC1090

export ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
export ZAP_DIR="$HOME/.local/share/zap"
export ZAP_PLUGIN_DIR="$ZAP_DIR/plugins"
export -a ZAP_INSTALLED_PLUGINS=()
fpath+="$ZAP_DIR/completion"

function plug() {

    function _try_source() {
        typeset -a extensions=(".plugin.zsh" ".zsh-theme" ".zsh")
        for ext in "${extensions[@]}"; do
            [[ -e "$plugin_dir/$plugin_name$ext" ]] && source "$plugin_dir/$plugin_name$ext" && return 0
            [[ -e "$plugin_dir/${plugin_name#zsh-}$ext" ]] && source "$plugin_dir/${plugin_name#zsh-}$ext" && return 0
        done
    }

    [[ -f "$1" ]] && source "$1" && return 0
    local plugin="$1"
    _try_source $plugin && return
    local git_ref="$2"
    local plugin_name=${plugin:t}
    local plugin_dir="$ZAP_PLUGIN_DIR/$plugin_name"
    if [ ! -d "$plugin_dir" ]; then
        echo "🔌 Zap is installing $plugin_name..."
        git clone "https://github.com/${plugin}.git" "$plugin_dir" > /dev/null 2>&1 || { echo -e "\e[1A\e[K❌ Failed to clone $plugin_name"; return 12 }
        echo -e "\e[1A\e[K⚡ Zap installed $plugin_name"
    fi
    [[ -n "$git_ref" ]] && { git -C "$plugin_dir" checkout "$git_ref" > /dev/null 2>&1 || { echo "❌ Failed to checkout $git_ref"; return 13 }}
    _try_source && { ZAP_INSTALLED_PLUGINS+="$plugin_name" && return 0 } || echo "❌ $plugin_name not activated" && return 1
}

function _pull() {
    echo "🔌 updating ${1:t}..."
    git -C $1 pull > /dev/null 2>&1 && { echo -e "\e[1A\e[K⚡ ${1:t} updated!"; return 0 } || { echo -e "\e[1A\e[K❌ Failed to pull"; return 14 }
}

function _zap_clean() {
    typeset -a unused_plugins=()
    for plugin in "$ZAP_PLUGIN_DIR"/*; do
        [[ "$ZAP_INSTALLED_PLUGINS[(Ie)${plugin:t}]" -eq 0 ]] && unused_plugins+=("${plugin:t}")
    done
    [[ ${#unused_plugins[@]} -eq 0 ]] && { echo "✅ Nothing to remove"; return 15 }
    for plug in ${unused_plugins[@]}; do
        echo "❔ Remove: $plug? (y/N)"
        read -qs answer
        [[ "$answer" == "y" ]] && { rm -rf "$ZAP_PLUGIN_DIR/$plug" && echo -e "\e[1A\e[K✅ Removed $plug" } || echo -e "\e[1A\e[K❕ skipped $plug"
    done
}

function _zap_update() {
    local _plugin _plug
    echo -e " 0  ⚡ Zap"
    for _plugin in ${ZAP_INSTALLED_PLUGINS[@]}; do
        echo "$ZAP_INSTALLED_PLUGINS[(Ie)$_plugin]  🔌 $_plugin"
    done
    echo -n "\n🔌 Plugin Number | (a) All Plugins | (0) ⚡ Zap Itself: "
    read _plugin
    echo ""
    if [[ $_plugin == "a" || $_plugin == "A" ]]; then
        for _plug in ${ZAP_INSTALLED_PLUGINS[@]}; do
            _pull "$ZAP_PLUGIN_DIR/$_plug"
        done
    elif [[ $_plugin -eq 0 ]]; then
        _pull "$ZAP_DIR"
    elif [[ $_plugin -gt ${#ZAP_INSTALLED_PLUGINS[@]} ]]; then
        echo "❌ Invalid option" && return 1
    else
        _pull "$ZAP_PLUGIN_DIR/$ZAP_INSTALLED_PLUGINS[$_plugin]"
    fi
    [[ $ZAP_CLEAN_ON_UPDATE == true ]] && _zap_clean || return 0
}

function _zap_help() {
    echo "Usage: zap <command>

COMMANDS:
    clean	Remove unused plugins
    help	Show this help message
    update	Update plugins
    version	Show version information"
}

function _zap_version() {
    local -r BLUE="\033[1;34m" GREEN="\033[1;32m" NOCOLOR="\033[0m"
    local _ver=${$(git -C $ZAP_DIR describe --tags HEAD)%%-*} _commit=${$(git -C $ZAP_DIR describe --tags HEAD)##*-}
    echo "⚡ Zap Version is ${GREEN}v${_ver}${NOCOLOR} on commit ${BLUE}${_commit#g}${NOCOLOR}"
}

function zap() {
    typeset -A subcmds=(
        clean "_zap_clean"
        help "_zap_help"
        update "_zap_update"
        version "_zap_version"
    )
    emulate -L zsh
    [[ -z "$subcmds[$1]" ]] && { echo 'Invalid option, see "zap help"'; return 1 } || ${subcmds[$1]}
}

# vim: ft=zsh ts=4 et
# Return codes:
#   0:  Success
#   1:  Invalid option
#   12: Failed to clone
#   13: Failed to checkout
#   14: Failed to pull
#   15: Nothing to remove
