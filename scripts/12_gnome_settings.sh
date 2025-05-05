#!/bin/bash

# GNOME Settings Configuration Script

echo "===== Configuring Gnome settings ====="
sudo apt install apt -y dbus-x11
gsettings set org.gnome.desktop.input-sources sources "[('ibus', 'hangul')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['korean:ralt_hangul', 'korean:rctrl_hanja']"
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 100
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'code.desktop', 'gitkraken_gitkraken.desktop', 'terminator.desktop', 'simplescreenrecorder.desktop']"
powerprofilesctl set performance
echo "===== Gnome settings configuration completed ====="
