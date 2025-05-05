#!/bin/bash

# Terminator Configuration Script

# Get parameters from parent script
REAL_USER="$1"
USER_HOME="$2"
SCRIPT_DIR="$3"

echo "===== Configuring Terminator settings ====="
mkdir -p $USER_HOME/.config/terminator
CONFIG_FILE="$USER_HOME/.config/terminator/config"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "[global_config]
[keybindings]
[profiles]
  [[default]]
    scrollback_infinite = True
[layouts]
[plugins]" > "$CONFIG_FILE"
    echo "infinite scrollback setting added to Terminator config."
else
    if ! grep -q "^\[profiles\]" "$CONFIG_FILE"; then
        echo -e "\n[profiles]\n  [[default]]\n    scrollback_infinite = True" >> "$CONFIG_FILE"
    else
        if ! grep -q "^\s*\[\[default\]\]" "$CONFIG_FILE"; then
            sed -i '/^\[profiles\]/a \  [[default]]\n    scrollback_infinite = True' "$CONFIG_FILE"
        else
            if grep -q "^\s*scrollback_infinite" "$CONFIG_FILE"; then
                sed -i 's/scrollback_infinite = .*/scrollback_infinite = True/g' "$CONFIG_FILE"
            else
                sed -i '/^\s*\[\[default\]\]/a \    scrollback_infinite = True' "$CONFIG_FILE"
            fi
        fi
    fi
fi
echo "===== Terminator configuration completed ====="
