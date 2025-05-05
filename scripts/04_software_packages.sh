#!/bin/bash

# Software Packages Installation Script

echo "===== Installing software packages ====="
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y software-properties-common apt-transport-https wget dbus-x11
sudo snap install tree
echo "===== Software installation completed ====="
