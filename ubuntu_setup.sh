#!/bin/bash

# Ubuntu Setup Tool - Main Script
# This script orchestrates the execution of modular setup scripts

# Determine the real user (even when the script is run with sudo)
if [ -n "$SUDO_USER" ]; then
  REAL_USER=$SUDO_USER
else
  REAL_USER=$(whoami)
fi

# Get the real user's home directory
if [ "$REAL_USER" = "root" ]; then
  USER_HOME="/root"
else
  USER_HOME=$(eval echo ~$REAL_USER)
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "===== Starting Ubuntu Installation Script ====="
echo "Running as user: $(whoami), Real user: $REAL_USER, Sudo user: $SUDO_USER"
echo "Home directory: $USER_HOME"
echo "Script directory: $SCRIPT_DIR"
cd $USER_HOME

sudo -v

# Set executable permissions for all script files
echo "Setting executable permissions for script files"
chmod +x "$SCRIPT_DIR/scripts"/*.sh
echo "Permissions set successfully."

# Run each setup script in sequence
echo "Running setup scripts"

# System configuration (GRUB and APT)
echo -e "\n===== System Configuration Script ====="
read -p "시스템 설정을 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/01_system_config.sh"
else
    echo "시스템 설정을 건너뜁니다."
fi

# Korean language configuration
echo -e "\n===== Korean Language Configuration Script ====="
read -p "한국어 언어 설정을 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/02_korean_config.sh"
else
    echo "한국어 언어 설정을 건너뜁니다."
fi

# NVIDIA driver installation
echo -e "\n===== NVIDIA Driver Installation Script ====="
read -p "NVIDIA 드라이버 설치를 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/03_nvidia_drivers.sh"
else
    echo "NVIDIA 드라이버 설치를 건너뜁니다."
fi

# Software packages installation
echo -e "\n===== Software Packages Installation Script ====="
read -p "소프트웨어 패키지 설치를 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/04_software_packages.sh"
else
    echo "소프트웨어 패키지 설치를 건너뜁니다."
fi

# Google Chrome installation
echo -e "\n===== Google Chrome Installation Script ====="
read -p "Google Chrome 설치를 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/05_chrome_install.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"
else
    echo "Google Chrome 설치를 건너뜁니다."
fi

# MATLAB installation
echo -e "\n===== MATLAB Installation Script ====="
read -p "MATLAB 설치를 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/06_matlab_install.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"
else
    echo "MATLAB 설치를 건너뜁니다."
fi

# Other software installation
echo -e "\n===== Other Software Installation Script ====="
read -p "기타 소프트웨어 설치를 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/07_other_software.sh"
else
    echo "기타 소프트웨어 설치를 건너뜁니다."
fi

# ROS2 Humble installation
echo -e "\n===== ROS2 Humble Installation Script ====="
read -p "ROS2 Humble 설치를 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/08_ros2_humble.sh"
else
    echo "ROS2 Humble 설치를 건너뜁니다."
fi

# Shell configuration and utility scripts
echo -e "\n===== Shell Configuration Script ====="
read -p "셸 설정을 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/09_shell_config.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"
else
    echo "셸 설정을 건너뜁니다."
fi

# Claude Code installation
echo -e "\n===== Claude Code Installation Script ====="
read -p "Claude Code 설치를 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/10_claude_code.sh"
else
    echo "Claude Code 설치를 건너뜁니다."
fi

# NAS connection setup
echo -e "\n===== NAS Connection Setup Script ====="
read -p "NAS 연결 설정을 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/11_nas_setup.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"
else
    echo "NAS 연결 설정을 건너뜁니다."
fi

# GNOME settings configuration
echo -e "\n===== GNOME Settings Configuration Script ====="
read -p "GNOME 설정을 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/12_gnome_settings.sh" "$REAL_USER"
else
    echo "GNOME 설정을 건너뜁니다."
fi

# Terminator configuration
echo -e "\n===== Terminator Configuration Script ====="
read -p "Terminator 설정을 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/13_terminator_config.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"
else
    echo "Terminator 설정을 건너뜁니다."
fi

# Docker installation
echo -e "\n===== Docker Installation Script ====="
read -p "Docker 설치를 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/14_docker_install.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"
else
    echo "Docker 설치를 건너뜁니다."
fi

# Clipboard manager setup
echo -e "\n===== Clipboard Manager Setup Script ====="
read -p "클립보드 매니저 설치를 실행하시겠습니까? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    sudo bash "$SCRIPT_DIR/scripts/15_clipboard_manager.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"
else
    echo "클립보드 매니저 설치를 건너뜁니다."
fi

# Source bashrc to apply changes
source $USER_HOME/.bashrc

# System reboot option
echo -e "\nAll setup tasks have been completed. System needs to be rebooted to apply changes."
read -p "Would you like to reboot now? (Y/n): " choice
if [[ $choice != "n" && $choice != "N" ]]; then
    echo "Rebooting"
    sudo reboot
else
    echo "Please reboot manually when convenient."
fi
