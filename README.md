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
  - GRUB timeout reduction
  - APT mirror configuration (Korean Kakao mirror)
  - Korean language input setup
  - GNOME desktop environment customization

- Software Installation
  - ROS2 Humble desktop
  - NVIDIA drivers (automatic detection and installation)
  - Google Chrome (specific version pinning)
  - MATLAB (interactive installation)
  - Visual Studio Code
  - GitKraken
  - Terminator with infinite scrollback
  - Development packages and utilities

- ROS2 Configuration
  - Complete ROS2 Humble installation
  - Colcon build tools
  - Environment setup
  - Convenient aliases for building projects

- Additional Tools
  - Xbox controller drivers (xpadneo)
  - Docker environment setup script
  - Workspace initialization script
  - Windows boot script for dual-boot systems
  - NAS connection configuration

- MCP Server Installation
  - Filesystem MCP server (@modelcontextprotocol/server-filesystem)
  - Agent Set MCP (@agentset/mcp)
  - YouTube MCP (@anaisbetts/mcp-youtube)
  - MCP Installer (@anaisbetts/mcp-installer)
  - Smithery CLI (@smithery/cli)
  - Papers With Code MCP (@hbg/mcp-paperswithcode)
  - arXiv MCP (arxiv-mcp-server)
  - Pandoc MCP (mcp-pandoc)

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

## Credits

This tool was developed to streamline the setup process for robotics development environments using ROS2 Humble on Ubuntu 22.04.

### Authors
- **Moon Seongjoon** - *Script developer and maintainer* - [janismoon](https://github.com/janismoon) - janismoon@korea.ac.kr

## License

This project is licensed under the MIT License - see the LICENSE file for details.
