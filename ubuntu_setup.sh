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
echo -e "\n===== Running System Configuration Script ====="
sudo bash "$SCRIPT_DIR/scripts/01_system_config.sh"

# Korean language configuration
echo -e "\n===== Running Korean Language Configuration Script ====="
sudo bash "$SCRIPT_DIR/scripts/02_korean_config.sh"

# NVIDIA driver installation
echo -e "\n===== Running NVIDIA Driver Installation Script ====="
sudo bash "$SCRIPT_DIR/scripts/03_nvidia_drivers.sh"

# Software packages installation
echo -e "\n===== Running Software Packages Installation Script ====="
sudo bash "$SCRIPT_DIR/scripts/04_software_packages.sh"

# Google Chrome installation
echo -e "\n===== Running Google Chrome Installation Script ====="
sudo bash "$SCRIPT_DIR/scripts/05_chrome_install.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"

# MATLAB installation
echo -e "\n===== Running MATLAB Installation Script ====="
sudo bash "$SCRIPT_DIR/scripts/06_matlab_install.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"

# Other software installation
echo -e "\n===== Running Other Software Installation Script ====="
sudo bash "$SCRIPT_DIR/scripts/07_other_software.sh"

# ROS2 Humble installation
echo -e "\n===== Running ROS2 Humble Installation Script ====="
sudo bash "$SCRIPT_DIR/scripts/08_ros2_humble.sh"

# Shell configuration and utility scripts
echo -e "\n===== Running Shell Configuration Script ====="
sudo bash "$SCRIPT_DIR/scripts/09_shell_config.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"

# MCP servers installation
echo -e "\n===== Running MCP Servers Installation Script ====="
sudo bash "$SCRIPT_DIR/scripts/10_mcp_servers.sh"

# NAS connection setup
echo -e "\n===== Running NAS Connection Setup Script ====="
sudo bash "$SCRIPT_DIR/scripts/11_nas_setup.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"

# GNOME settings configuration
echo -e "\n===== Running GNOME Settings Configuration Script ====="
sudo bash "$SCRIPT_DIR/scripts/12_gnome_settings.sh"

# Terminator configuration
echo -e "\n===== Running Terminator Configuration Script ====="
sudo bash "$SCRIPT_DIR/scripts/13_terminator_config.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"

# Docker installation
echo -e "\n===== Running Docker Installation Script ====="
sudo bash "$SCRIPT_DIR/scripts/14_docker_install.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"

# Clipboard manager setup
echo -e "\n===== Running Clipboard Manager Setup Script ====="
sudo bash "$SCRIPT_DIR/scripts/15_clipboard_manager.sh" "$REAL_USER" "$USER_HOME" "$SCRIPT_DIR"

# Source bashrc to apply changes
source $USER_HOME/.bashrc

# System reboot option
echo -e "\nAll setup tasks have been completed. System needs to be rebooted to apply changes."
read -p "Would you like to reboot now? (y/n): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "Rebooting"
    sudo reboot
else
    echo "Please reboot manually when convenient."
fi
