#!/bin/bash

# Get parameters from parent script
REAL_USER="$1"
USER_HOME="$2"
SCRIPT_DIR="$3"

echo "===== Installing and configuring clipboard manager ====="

# Install CopyQ clipboard manager
echo "Installing CopyQ clipboard manager"
sudo apt update
sudo apt install -y copyq

# Create the autostart directory if it doesn't exist
mkdir -p $USER_HOME/.config/autostart

# Create autostart file for CopyQ
echo "Configuring CopyQ to start automatically"
cat > $USER_HOME/.config/autostart/copyq.desktop << 'EOF'
[Desktop Entry]
Name=CopyQ
Icon=copyq
GenericName=Clipboard Manager
Comment=Advanced clipboard manager with editing and scripting features
Exec=env QT_QPA_PLATFORM=xcb copyq
Terminal=false
Type=Application
Categories=Qt;KDE;Utility;
X-GNOME-Autostart-enabled=true
EOF

# Set proper permissions for the autostart file
sudo chown $REAL_USER:$REAL_USER $USER_HOME/.config/autostart/copyq.desktop
sudo chmod +x $USER_HOME/.config/autostart/copyq.desktop

# Removing Super+V shortcut from system
if [ "$(whoami)" != "$REAL_USER" ]; then
    super_v_settings=$(sudo -u $REAL_USER -H bash -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $REAL_USER)/bus gsettings list-recursively | grep -F '<Super>v'")
else
    super_v_settings=$(gsettings list-recursively | grep -F '<Super>v')
fi

if [ -z "$super_v_settings" ]; then
    echo "No Super+V shortcut found."
else
    echo "Found the following Super+V shortcuts:"
    echo "$super_v_settings"
    echo ""

    echo "$super_v_settings" | while read -r line; do
        schema=$(echo "$line" | awk '{print $1}')
        key=$(echo "$line" | awk '{print $2}')

        echo "Processing: $schema $key"

        if [ "$(whoami)" != "$REAL_USER" ]; then
            current_value=$(sudo -u $REAL_USER -H bash -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $REAL_USER)/bus gsettings get $schema $key")
        else
            current_value=$(gsettings get $schema $key)
        fi

        echo "Current value: $current_value"

        if [[ "$current_value" == *"'<Super>v'"* ]]; then
            if [[ "$current_value" == "['<Super>v']" ]]; then
                new_value="@as []"
            elif [[ "$current_value" == *"'<Super>v', "* ]]; then
                new_value=$(echo "$current_value" | sed "s/'<Super>v', //")
            elif [[ "$current_value" == *", '<Super>v'"* ]]; then
                new_value=$(echo "$current_value" | sed "s/, '<Super>v'//")
            fi

            if [ "$(whoami)" != "$REAL_USER" ]; then
                sudo -u $REAL_USER -H bash -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $REAL_USER)/bus gsettings set $schema $key \"$new_value\""
            else
                gsettings set $schema $key "$new_value"
            fi

            echo "Changed to: $new_value"
        fi
        echo ""
    done
    echo "Super+V shortcut conflicts have been removed."
fi

# Setting up Super+V shortcut for CopyQ
echo "Setting up Super+V shortcut for CopyQ"
CONFIG_DIR="$USER_HOME/.config/copyq"
mkdir -p "$CONFIG_DIR"

# CopyQ configuration file creation (if it doesn't exist)
if [ ! -f "$CONFIG_DIR/copyq.conf" ]; then
    touch "$CONFIG_DIR/copyq.conf"
fi

# Create command settings file
cat > "$CONFIG_DIR/shortcuts.ini" << 'EOF'
[Commands]
1\Command=copyq: showAt()
1\GlobalShortcut=meta+v
1\Icon=\xf022
1\IsGlobalShortcut=true
1\Name=Show/hide main window
size=1
EOF

# Set proper permissions
chown -R $REAL_USER:$REAL_USER "$CONFIG_DIR"

# Setting up Super+V as a system custom shortcut
echo "Setting up Super+V as a system custom shortcut..."

# Get current custom shortcuts list
if [ "$(whoami)" != "$REAL_USER" ]; then
    CUSTOM_KEYS=$(sudo -u $REAL_USER -H bash -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $REAL_USER)/bus gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings")
else
    CUSTOM_KEYS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
fi

# Initialize if custom shortcuts are empty or don't exist
if [ "$CUSTOM_KEYS" = "@as []" ] || [ -z "$CUSTOM_KEYS" ]; then
    CUSTOM_KEYS="['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
    NEXT_KEY=0
else
    # Find the last number
    LAST_KEY=$(echo $CUSTOM_KEYS | grep -o "custom[0-9]\+" | sed 's/custom//' | sort -n | tail -1)
    NEXT_KEY=$((LAST_KEY + 1))

    # Remove brackets
    CUSTOM_KEYS=$(echo $CUSTOM_KEYS | sed 's/\[//' | sed 's/\]//')

    # Add new key path
    NEW_PATH="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$NEXT_KEY/'"
    CUSTOM_KEYS="[$CUSTOM_KEYS, $NEW_PATH]"
fi

echo "New shortcut path: custom$NEXT_KEY"

# Update custom shortcuts list
if [ "$(whoami)" != "$REAL_USER" ]; then
    sudo -u $REAL_USER -H bash -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $REAL_USER)/bus gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \"$CUSTOM_KEYS\""
else
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$CUSTOM_KEYS"
fi

# Set up new shortcut
NEW_KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$NEXT_KEY/"
echo "Setting up new shortcut: $NEW_KEY_PATH"

# Set name, command, and shortcut
if [ "$(whoami)" != "$REAL_USER" ]; then
    sudo -u $REAL_USER -H bash -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $REAL_USER)/bus gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_KEY_PATH name \"CopyQ Clipboard Manager\""
    sudo -u $REAL_USER -H bash -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $REAL_USER)/bus gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_KEY_PATH command \"copyq -e \\\"toggle()\\\"\""
    sudo -u $REAL_USER -H bash -c "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $REAL_USER)/bus gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_KEY_PATH binding \"<Super>v\""
else
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_KEY_PATH name "CopyQ Clipboard Manager"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_KEY_PATH command "copyq -e \"toggle()\""
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_KEY_PATH binding "<Super>v"
fi

echo "===== Clipboard manager installation and configuration complete ====="
