#!/bin/bash

# Korean Language Configuration Script

echo "===== Configuring Korean input ====="
sudo gnome-language-selector
sudo apt install -y $(check-language-support -l ko) ibus-hangul
ibus restart
sudo sed -i 's/symbols\[Group1\] = \[ Alt_R, Meta_R \] };/symbols[Group1] = [ Hangul ] };/g' /usr/share/X11/xkb/symbols/altwin
echo "===== Korean input configuration completed ====="
