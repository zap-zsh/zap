#!/bin/sh

export ZAP_DIR="$HOME/.local/share/zap"
export ZAP_PLUGIN_DIR="$ZAP_DIR/plugins"

function plug() {
	plugin="$1"
    if [ -f "$plugin" ]; then
		source "$plugin"
	else
		local full_path="${ZAP_PLUGIN_DIR}/${plugin}"
		local plugin_dir="$(dirname $full_path)"
		local plugin_name="$(basename $full_path)"
		if [ ! -d "$full_path" ]; then
			echo "🔌$plugin_name"
			git clone "https://github.com/${plugin}.git" "$full_path" > /dev/null 2>&1
			if [[ ! -z $2 ]]; then                                              # check if the second arg of zapplug exist
				cd $plugin_dir && git checkout "$2" > /dev/null 2>&1 && cd      # checkout the desidered commit
			fi
			if [ $? -ne 0 ]; then
				echo "Failed to install $plugin_name"
				exit 1
			fi
			echo -e "\e[1A\e[K⚡$plugin_name"
		fi
		source "${full_path}/${plugin_name}.zsh" > /dev/null 2>&1 || \
		source "${full_path}/${plugin_name}.plugin.zsh" > /dev/null 2>&1 || \
		source "${full_path}/${plugin_name}.zsh-theme" > /dev/null 2>&1 
	fi
}

function _pull () {
    echo "🔌$1"
    git pull > /dev/null 1>&1
    if [ $? -ne 0 ]; then
        echo "Failed to Update $1"
        exit 1
    fi
    echo -e "\e[1A\e[K⚡$1"
}

update () {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo ""
    echo "Plugin Name / (a) for All Plugins / (self) for Zap Itself: "
    read plugin;
    pwd=$(pwd)
    echo ""
    if [[ $plugin == "a" ]]; then
        cd "$ZAP_PLUGIN_DIR"
        for plug in *; do
            cd $plug
            _pull $plug
            cd ..;
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

delete () {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo -n "Plugin Name: ";
    read plugin;
    cd "$ZAP_PLUGIN_DIR" && echo "Deleting $plugin ..." && rm -rf $plugin > /dev/null 2>&1 && cd - > /dev/null 2>&1 && echo "Deleted $plugin " || echo "Failed to delete : $plugin"
}

pause() {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo ""
    echo -n "Plugin Name or (a) to Update All: ";
    read plugin;
    if [[ $plugin == "a" ]]; then
      sed -i '/^zapplug/s/^/#/g' ~/.zshrc
    else
      sed -i "/\/$plugin/s/^/#/g" ~/.zshrc
    fi
}

unpause() {
    ls -1 "$ZAP_PLUGIN_DIR"
    echo ""
    echo -n "Plugin Name or (a) to Update All: ";
    read plugin;
    if [[ $plugin == "a" ]]; then
      sed -i '/^#zapplug/s/^#//g' ~/.zshrc
    else
      sed -i "/\/$plugin/s/^#//g" ~/.zshrc
    fi
}

Help () {
  cat "$ZAP_DIR/doc.txt"
}

Version () {
  ref=$ZAP_DIR/.git/packed-refs
  tag=$(awk 'BEGIN { FS = "[ /]" } { print $3, $4 }' $ref | grep tags);
  ver=$(echo $tag | cut -d " " -f 2)
  echo "⚡Zap Version v$ver" 
}

function zap() {
    local command="$1"
    if [[ "$command" == "-v" ]] || [[ "$command" == "--version" ]]; then
       Version;
       return;
    else
      if [[ "$command" == "-h" ]] || [[ "$command" == "--help" ]]; then
        Help;
        return;
      else
       $command;
        return;
      fi
      echo "$command: command not found"
    fi 
}

