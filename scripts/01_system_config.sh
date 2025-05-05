#!/bin/bash

# System Configuration Script (GRUB and APT)

echo "===== Configuring GRUB settings ====="
sudo sed -i 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=1/' /etc/default/grub
sudo update-grub
echo "===== GRUB configuration completed ====="

echo
echo "===== Configuring APT mirror ====="
sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/' /etc/apt/sources.list
sudo apt update -y
sudo apt upgrade -y
echo "===== APT configuration completed ====="
