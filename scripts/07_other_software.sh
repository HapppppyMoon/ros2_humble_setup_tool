#!/bin/bash

# Other Software Installation Script

echo "===== Installing other software packages ====="
sudo apt install -y terminator barrier vlc simplescreenrecorder kolourpaint git

# VS Code Installation
echo
echo "===== Installing Visual Studio Code ====="
wget -O- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg
echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code
echo "===== Visual Studio Code installation completed ====="

# xpadneo Installation
echo
echo "===== Installing xpadneo (Xbox controller driver) ====="
sudo apt install apt -y dkms linux-headers-`uname -r`
git clone https://github.com/atar-axis/xpadneo.git
cd xpadneo
yes | sudo ./install.sh
cd -
sudo rm -rf xpadneo
echo "===== xpadneo installation completed ====="
