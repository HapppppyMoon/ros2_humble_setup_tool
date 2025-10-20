# ROS2 Humble Setup Tool for Ubuntu 22.04

A comprehensive setup script for configuring Ubuntu 22.04 (Jammy Jellyfish) with ROS2 Humble and essential development tools.

## Description

This tool automates the installation and configuration process for a complete development environment on Ubuntu 22.04. It's designed for robotics developers, researchers, and enthusiasts who need a quick setup for ROS2 Humble and related tools.

The script configures system settings, installs necessary software packages, sets up Korean language support, configures ROS2 Humble, and creates utility scripts for daily development workflow.

## System Requirements

- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Administrator (sudo) privileges
- Internet connection
- At least 20GB of free disk space
- Recommended: NVIDIA GPU for driver installation

## Features

- System Configuration
  - GRUB timeout reduction (01_system_config.sh)
  - APT mirror configuration (Korean Kakao mirror) (01_system_config.sh)
  - Korean language input setup (02_korean_config.sh)
  - GNOME desktop environment customization (12_gnome_settings.sh)

- Software Installation
  - ROS2 Humble desktop (08_ros2_humble.sh)
  - NVIDIA drivers (automatic detection and installation) (03_nvidia_drivers.sh)
  - Google Chrome (specific version pinning) (05_chrome_install.sh)
  - MATLAB (interactive installation) (06_matlab_install.sh)
  - Visual Studio Code (07_other_software.sh)
  - Terminator with infinite scrollback (13_terminator_config.sh)
  - Docker CE with NVIDIA Container Toolkit support (14_docker_install.sh)
  - CopyQ clipboard manager with Super+V shortcut (15_clipboard_manager.sh)
  - Development packages and utilities (04_software_packages.sh)

- ROS2 Configuration
  - Complete ROS2 Humble installation (08_ros2_humble.sh)
  - Colcon build tools (08_ros2_humble.sh)
  - Environment setup (09_shell_config.sh)
  - Convenient aliases for building projects (09_shell_config.sh)

- Additional Tools
  - Xbox controller drivers (xpadneo) (07_other_software.sh)
  - Workspace initialization script (09_shell_config.sh)
  - Windows boot script for dual-boot systems (09_shell_config.sh)
  - NAS connection configuration (11_nas_setup.sh)

- Claude Code Installation (10_claude_code.sh)
  - nvm (Node Version Manager) - latest version
  - Node.js LTS (Long Term Support) version
  - Claude Code CLI tool (@anthropic-ai/claude-code)
  - Automatic version management without hardcoded versions

## Installation

1. Clone this repository:
```bash
git clone https://github.com/username/ros2_humble_setup_tool.git
cd ros2_humble_setup_tool
```

2. Make the script executable:
```bash
chmod +x ubuntu_setup.sh
```

3. Run the script:
```bash
./ubuntu_setup.sh
```

4. Interactive Components:
   - Korean input setup: When the language selector opens, click the 'Install' button if prompted to install additional language packages
   - MATLAB installation: You need to manually download the MATLAB installation file (browser will open automatically)
   - NAS connection: You will be prompted to enter your Synology NAS server address, username, and password
   - **Important**: When setting up the keyring password at the end of installation, leave it blank for automatic connections after system reboot

## Usage

The script will guide you through the installation process with clear prompts. After installation, you'll have several utility scripts available in your home directory:

- `initiate_bash.sh`: Interactive tool to select ROS2 version, MATLAB version, and workspace path
- `docker_run.sh`: Script for launching Docker containers with proper configuration
- `go_windows.sh`: Quick reboot to Windows for dual-boot systems (accessible via desktop shortcut `go_windows.desktop` for easy double-click execution)

## Post-Installation

After installation, the system will be configured with:

1. ROS2 Humble and development tools
2. Convenient aliases in `.bashrc` for ROS2 development:
   - `cbd`: Clear and build in debug mode
   - `cbr`: Clear and build in release mode

3. Environment variables in `.bashrc`:
   - `ROS_DOMAIN_ID=30`: Sets the ROS domain ID
   - Language settings: `LANG=en_US.UTF-8`
   - ROS console formatting: `RCUTILS_CONSOLE_OUTPUT_FORMAT='[{severity}]: {message}'`
   - Colorized output: `RCUTILS_COLORIZED_OUTPUT=1`
   - Logging settings: `RCUTILS_LOGGING_USE_STDOUT=0` and `RCUTILS_LOGGING_BUFFERED_STREAM=1`

4. Auto-sourced tools in `.bashrc`:
   - Colcon argument completion
   - VCS tool completion
   - Colcon directory functions
   - Custom workspace initialization script

5. Korean language support with proper input method configuration
6. Dark mode GNOME theme with customized dock settings
7. Terminator with infinite scrollback configuration
8. NAS connection setup for shared storage
9. Performance power profile activation
10. Custom keyboard shortcuts:
    - `Super+V`: Open CopyQ clipboard manager (with clipboard history)
    - Automatic conflict resolution for shortcut keys

## ROS2 Workspace Setup

After installing ROS2 Humble, you can create and set up a ROS2 workspace:

```bash
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
```

Install dependencies for your ROS2 packages:
```bash
rosdep install --from-paths src -y --ignore-src
```

Build your workspace:
```bash
colcon build
```

## Available Scripts

The setup tool includes the following scripts:
- 01_system_config.sh: Basic system configuration
- 02_korean_config.sh: Korean language support
- 03_nvidia_drivers.sh: NVIDIA drivers installation
- 04_software_packages.sh: Common software packages
- 05_chrome_install.sh: Google Chrome installation
- 06_matlab_install.sh: MATLAB installation
- 07_other_software.sh: Additional software
- 08_ros2_humble.sh: ROS2 Humble installation
- 09_shell_config.sh: Shell configuration including aliases
- 10_claude_code.sh: Claude Code CLI installation
- 11_nas_setup.sh: NAS configuration
- 12_gnome_settings.sh: GNOME desktop settings
- 13_terminator_config.sh: Terminator terminal configuration
- 14_docker_install.sh: Docker installation
- 15_clipboard_manager.sh: Clipboard manager setup

## Credits

This tool was developed to streamline the setup process for robotics development environments using ROS2 Humble on Ubuntu 22.04.

### Authors
- **Moon Seongjoon** - *Script developer and maintainer* - [janismoon](https://github.com/janismoon) - janismoon@korea.ac.kr

## License

This project is licensed under the MIT License - see the LICENSE file for details.
