#!/bin/bash

# GNOME Settings Configuration Script

# Get real user from parameters or environment
REAL_USER=${1:-$SUDO_USER}
REAL_USER=${REAL_USER:-$USER}

# Get the real user's UID
USER_ID=$(id -u $REAL_USER)

echo "===== Configuring Gnome settings for user: $REAL_USER (UID: $USER_ID) ====="
sudo apt install apt -y dbus-x11

# Run gsettings as the real user with proper DBUS session
run_gsettings() {
    sudo -u $REAL_USER DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USER_ID/bus DISPLAY=:0 gsettings "$@"
}

run_gsettings set org.gnome.desktop.input-sources sources "[('ibus', 'hangul')]"
run_gsettings set org.gnome.desktop.input-sources xkb-options "['korean:ralt_hangul', 'korean:rctrl_hanja']"
run_gsettings set org.gnome.desktop.session idle-delay 0
run_gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
run_gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 100
run_gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
run_gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
run_gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
run_gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
run_gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
run_gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
run_gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
run_gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'code.desktop', 'terminator.desktop', 'simplescreenrecorder.desktop']"
powerprofilesctl set performance
echo "===== Gnome settings configuration completed ====="
