#!/bin/bash

# Ubuntu Installation Script

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

echo "===== Starting Ubuntu Installation Script ====="
echo "Running as user: $(whoami), Real user: $REAL_USER, Sudo user: $SUDO_USER"
echo "Home directory: $USER_HOME"
cd $USER_HOME

sudo -v

# GRUB Configuration
echo
echo "===== Configuring GRUB settings ====="
sudo sed -i 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=1/' /etc/default/grub
sudo update-grub
echo "===== GRUB configuration completed ====="

# APT Configuration
echo
echo "===== Configuring APT mirror ====="
sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/' /etc/apt/sources.list
sudo apt update -y
sudo apt upgrade -y
echo "===== APT configuration completed ====="

# Korean Input Configuration
echo
echo "===== Configuring Korean input ====="
sudo gnome-language-selector
sudo apt install -y $(check-language-support -l ko) ibus-hangul
ibus restart
sudo sed -i 's/symbols\[Group1\] = \[ Alt_R, Meta_R \] };/symbols[Group1] = [ Hangul ] };/g' /usr/share/X11/xkb/symbols/altwin
echo "===== Korean input configuration completed ====="

# NVIDIA Driver Installation
echo
echo "===== Installing NVIDIA drivers ====="
sudo ubuntu-drivers autoinstall
echo "===== NVIDIA driver installation completed ====="

# Software Installation
echo
echo "===== Installing software packages ====="
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y software-properties-common apt-transport-https wget dbus-x11
sudo snap install tree
echo "===== Software installation completed ====="

# Chrome Installation
echo
echo "===== Installing Google Chrome ====="
TARGET_VERSION="134.0.6998.88-1"
echo "Checking Google Chrome version..."
cd $USER_HOME/Downloads/
if command -v google-chrome &> /dev/null; then
    CURRENT_VERSION=$(google-chrome --version | cut -d ' ' -f 3)
    FORMATTED_VERSION=$(echo $CURRENT_VERSION | cut -d '.' -f 1-4)
    TARGET_CHECK=$(echo $TARGET_VERSION | cut -d '-' -f 1)

    echo "Current Chrome version: $FORMATTED_VERSION"
    echo "Target Chrome version: $TARGET_CHECK"

    if [ "$FORMATTED_VERSION" = "$TARGET_CHECK" ]; then
        echo "Chrome $TARGET_VERSION is already installed. Skipping installation."
        sudo apt-mark hold google-chrome-stable
    else
        echo "Installing Google Chrome $TARGET_VERSION..."
        wget https://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_${TARGET_VERSION}_amd64.deb
        sudo apt install -y ./google-chrome-stable_${TARGET_VERSION}_amd64.deb --allow-downgrades
        sudo rm google-chrome-stable_${TARGET_VERSION}_amd64.deb
        sudo apt-mark hold google-chrome-stable
    fi
else
    echo "Google Chrome is not installed. Installing version $TARGET_VERSION..."
    wget https://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_${TARGET_VERSION}_amd64.deb
    sudo apt install -y ./google-chrome-stable_${TARGET_VERSION}_amd64.deb --allow-downgrades
    sudo rm google-chrome-stable_${TARGET_VERSION}_amd64.deb
    sudo apt-mark hold google-chrome-stable
fi
google-chrome
cd $USER_HOME
echo "===== Google Chrome installation completed ====="

# MATLAB Installation
echo
echo "===== Installing MATLAB ====="

check_matlab_installation() {
    # Method 1: Check common installation directory
    if [ -d "/usr/local/MATLAB" ]; then
        return 0
    fi

    # Method 2: Check using whereis command
    if whereis matlab | grep -q "/usr/local/"; then
        return 0
    fi

    # Method 3: Check using which command
    if which matlab &>/dev/null; then
        return 0
    fi

    # MATLAB not found
    return 1
}

if check_matlab_installation; then
    echo "MATLAB appears to be already installed on this system."
    read -p "Do you want to proceed with installation anyway? (y/n): " answer

    # Convert to lowercase
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

    if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
        echo "Continuing with installation as requested..."
    else
        echo "Installation cancelled by user. MATLAB is already installed."
        proceed_with_installation=false
    fi
else
    echo "MATLAB is not installed. Proceeding with installation..."
fi

if $proceed_with_installation; then
    echo "Please log in and start the download of MATLAB for Linux."
    xdg-open "https://kr.mathworks.com/downloads/"

    while true; do
        # Check if the file exists (using wildcard for version flexibility)
        if ls $USER_HOME/Downloads/matlab_R*.zip 1> /dev/null 2>&1; then
            # Get the exact filename for future use
            MATLAB_ZIP=$(ls $USER_HOME/Downloads/matlab_R*.zip)
            MATLAB_DIR=$(basename "$MATLAB_ZIP" .zip)
            echo "Installation file found: $MATLAB_ZIP"
            break
        fi
        echo "Waiting for download to complete..."
        sleep 5
    done

    cd $USER_HOME/Downloads/
    sudo unzip -X -K "$MATLAB_ZIP" -d "$MATLAB_DIR"
    cd $USER_HOME/Downloads/"$MATLAB_DIR"/
    sudo ./install
    sudo rm -rf $USER_HOME/Downloads/"$MATLAB_DIR" "$MATLAB_ZIP"
fi
cd $USER_HOME
echo "===== MATLAB installation completed ====="

# Other Software
echo
echo "===== Installing other software packages ====="
sudo apt install -y terminator barrier vlc simplescreenrecorder kolourpaint git
echo "===== Other software installation completed ====="

# VS Code Installation
echo
echo "===== Installing Visual Studio Code ====="
wget -O- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg
echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code
echo "===== Visual Studio Code installation completed ====="

# GitKraken Installation
echo
echo "===== Installing GitKraken ====="
sudo snap install gitkraken --classic
echo "===== GitKraken installation completed ====="

# xpadneo Installation
echo
echo "===== Installing xpadneo (Xbox controller driver) ====="
sudo apt install apt -y dkms linux-headers-`uname -r`
git clone https://github.com/atar-axis/xpadneo.git
cd xpadneo
yes | sudo ./install.sh
cd $USER_HOME
sudo rm -rf $USER_HOME/xpadneo
echo "===== xpadneo installation completed ====="

# ROS2 Humble Installation
echo
echo "===== Installing ROS2 Humble ====="

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # Verify settings

sudo apt -y install software-properties-common
sudo add-apt-repository universe -y

sudo apt update && sudo apt install -y curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y ros-humble-desktop python3-colcon-common-extensions python3-colcon-argcomplete python3-vcstool
echo "===== ROS2 Humble installation completed ====="

# Shell Scripts and .bashrc Configuration
echo
echo "===== Creating shell scripts and configuring .bashrc ====="

# Creating docker_run.sh
if [ ! -f $USER_HOME/docker_run.sh ]; then
    cat > $USER_HOME/docker_run.sh << 'DOCKEREOF'
#!/bin/bash

sudo -v

if [ -n "$SUDO_USER" ]; then
  REAL_USER=$SUDO_USER
else
  REAL_USER=$(whoami)
fi

# Parameters: image name, container name, and local repository path
# Your Bash Command will be like this
# ./docker_run.sh janismoon/mobis_code_env:1.0 mobis_code /media/$REAL_USER/ext_hdd/git_repos/HGG-CBS
IMAGE_NAME=${1:-janismoon/mobis_code_env:1.0}
CONTAINER_NAME=${2:-mobis_code}
LOCAL_REPO_PATH=${3:-/media/$REAL_USER/ext_hdd/git_repos/MultiRobotSystem2}

# Stopping and removing the existing container, if it exists
sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME

# Running the Docker container
sudo docker run --privileged -it \
-e NVIDIA_DRIVER_CAPABILITIES=all \
-e NVIDIA_VISIBLE_DEVICES=all \
--volume=$LOCAL_REPO_PATH:/root/workspace \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:rw \
--net=host \
--ipc=host \
--shm-size=12gb \
--name=$CONTAINER_NAME \
--cpus=24 \
--memory=96gb \
--env="DISPLAY=$DISPLAY" \
$IMAGE_NAME

# Exiting the script
exit
DOCKEREOF
    echo "docker_run.sh script created successfully."
else
    echo "docker_run.sh already exists."
fi

# Creating initiate_bash.sh
if [ ! -f $USER_HOME/initiate_bash.sh ]; then
    cat > $USER_HOME/initiate_bash.sh << 'INITIATEEOF'
#!/bin/bash

# Print title
echo "====================================="
echo "ROS2, MATLAB, Workspace Setup Tool"
echo "====================================="

# ROS2 Version Selection Menu
function select_ros2_version() {
    echo -e "\n[Select ROS2 Version]"

    # Find installed ROS2 versions
    if [ -d /opt/ros ]; then
        ROS_VERSIONS=($(ls -1 /opt/ros))

        if [ ${#ROS_VERSIONS[@]} -eq 0 ]; then
            echo "Cannot find installed ROS2 versions."
            return 1
        fi

        if [ ${#ROS_VERSIONS[@]} -eq 1 ]; then
            ros_version=${ROS_VERSIONS}
            echo "Only one ROS2 version found: $ros_version. Automatically selecting it."
            source /opt/ros/$ros_version/setup.bash
            return 0
        fi

        PS3="Select ROS2 version (number): "
        select ros_version in "${ROS_VERSIONS[@]}" "Skip"; do
            if [ "$ros_version" = "Skip" ]; then
                echo "Skipping ROS2 setup."
                return 0
            elif [ -n "$ros_version" ]; then
                echo "Selected ROS2 version: $ros_version"
                source /opt/ros/$ros_version/setup.bash
                return 0
            else
                echo "Invalid selection. Please try again."
            fi
        done
    else
        echo "ROS2 is not installed."
        return 1
    fi
}

# MATLAB Version Selection Menu
function select_matlab_version() {
    echo -e "\n[Select MATLAB Version]"

    # Find installed MATLAB versions
    MATLAB_DIR="/usr/local/MATLAB"
    if [ -d "$MATLAB_DIR" ]; then
        MATLAB_VERSIONS=($(ls -1 $MATLAB_DIR | grep -E "R[0-9]{4}[ab]?" | sort -r))

        if [ ${#MATLAB_VERSIONS[@]} -eq 0 ]; then
            echo "Cannot find installed MATLAB versions."
            return 1
        fi

        if [ ${#MATLAB_VERSIONS[@]} -eq 1 ]; then
            matlab_version=${MATLAB_VERSIONS}
            echo "Only one MATLAB version found: $matlab_version. Automatically selecting it."
            alias matlab="cd $MATLAB_DIR/$matlab_version/bin && sudo chmod -R o+w . && ./matlab"
            return 0
        fi

        PS3="Select MATLAB version (number): "
        select matlab_version in "${MATLAB_VERSIONS[@]}" "Skip"; do
            if [ "$matlab_version" = "Skip" ]; then
                echo "Skipping MATLAB setup."
                return 0
            elif [ -n "$matlab_version" ]; then
                echo "Selected MATLAB version: $matlab_version"
                alias matlab="cd $MATLAB_DIR/$matlab_version/bin && sudo chmod -R o+w . && ./matlab"
                return 0
            else
                echo "Invalid selection. Please try again."
            fi
        done
    else
        echo "MATLAB is not installed."
        return 1
    fi
}

# Input workspace path
function input_workspace_path() {
    echo -e "\n[Input Workspace Path]"

    echo "Enter workspace path (press Enter to skip): "
    read input_path

    if [ -z "$input_path" ]; then
        echo "Skipping workspace setup."
        return 0
    fi

    # Expand ~ to home directory
    workspace_path=$(eval echo "$input_path")

    if [ -d "$workspace_path" ]; then
        if [ -f "$workspace_path/install/setup.bash" ]; then
            echo "Setting up workspace: $workspace_path"
            source $workspace_path/install/setup.bash
        else
            echo "install/setup.bash file not found, but moving to path: $workspace_path"
        fi
        cd "$workspace_path"
        return 0
    else
        echo "Cannot find path: $workspace_path"
        echo "Try again? (y/n)"
        read retry
        if [[ "$retry" == "y" || "$retry" == "Y" ]]; then
            input_workspace_path
        fi
        return 1
    fi
}

# Main function execution
select_ros2_version
select_matlab_version
input_workspace_path

echo -e "\nSetup complete!"
INITIATEEOF
    echo "initiate_bash.sh script created successfully."
else
    echo "initiate_bash.sh already exists."
fi

# Creating go_windows.sh
if [ ! -f $USER_HOME/go_windows.sh ]; then
    mkdir -p $USER_HOME
    cat > $USER_HOME/go_windows.sh << 'WINDOWSEOF'
#!/bin/bash
sudo -v
sudo grub-reboot 2
sudo reboot

exit
WINDOWSEOF
    echo "go_windows.sh script created on $USER_HOME successfully."
else
    echo "go_windows.sh already exists on $USER_HOME."
fi

# Create .desktop file for go_windows.sh on Desktop
if [ ! -f $USER_HOME/Desktop/go_windows.desktop ]; then
  mkdir -p $USER_HOME/Desktop
  cat > $USER_HOME/Desktop/go_windows.desktop << DESKTOPEOF
[Desktop Entry]
Type=Application
Name=Reboot to Windows
Comment=Reboot to Windows
Exec=gnome-terminal -e "bash -c 'sudo $USER_HOME/go_windows.sh; exec bash'"
Icon=system-reboot
Terminal=true
Categories=System;
DESKTOPEOF
  echo "go_windows.desktop file created on Desktop successfully."
else
  echo "go_windows.desktop already exists on Desktop."
fi
gio set $USER_HOME/Desktop/go_windows.desktop metadata::trusted true

# Setting execute permissions
for file in $USER_HOME/docker_run.sh $USER_HOME/initiate_bash.sh $USER_HOME/go_windows.sh $USER_HOME/Desktop/go_windows.desktop; do
    if [ -f "$file" ]; then
        sudo chmod +x "$file"
        sudo chown $REAL_USER:$REAL_USER "$file"
        echo "Execute permission set for $file"
    fi
done

# Updating .bashrc
if ! grep -Fq "export ROS_DOMAIN_ID=30" $USER_HOME/.bashrc; then
    cat >> $USER_HOME/.bashrc << 'BASHRCEOF'

export ROS_DOMAIN_ID=30
export LANG=en_US.UTF-8
export RCUTILS_CONSOLE_OUTPUT_FORMAT='[{severity}]: {message}'
export RCUTILS_COLORIZED_OUTPUT=1
export RCUTILS_LOGGING_USE_STDOUT=0
export RCUTILS_LOGGING_BUFFERED_STREAM=1

source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
source /usr/share/vcstool-completion/vcs.bash
source /usr/share/colcon_cd/function/colcon_cd.sh
source ~/initiate_bash.sh

alias cbd='clear && sudo rm -rf ./log ./build ./install && colcon build --symlink-install --cmake-args " -DCMAKE_BUILD_TYPE=Debug" && clear'
alias cbr='clear && sudo rm -rf ./log ./build ./install && colcon build --symlink-install --cmake-args " -DCMAKE_BUILD_TYPE=Release" && clear'
BASHRCEOF
    echo ".bashrc updated with ROS2 configuration and aliases."
else
    echo ".bashrc already has the necessary configuration."
fi
source $USER_HOME/.bashrc
echo "===== Creating shell scripts and configuring .bashrc completed ====="

# Install MCP Servers
echo
echo "===== Installing MCP servers ====="
sudo apt update -y
sudo apt upgrade -y
sudo apt install nodejs npm -y

sudo npm cache clean -f
sudo npm install -g n
sudo n lts

yes | sudo npm install -g @modelcontextprotocol/server-filesystem @agentset/mcp @anaisbetts/mcp-youtube @anaisbetts/mcp-installer @smithery/cli

yes | npx @smithery/cli install @hbg/mcp-paperswithcode --client vscode --key "08295ed0-294e-45a9-b1ef-2e02d5933c18" --no-sandbox
yes | npx @smithery/cli install arxiv-mcp-server --client vscode --key "08295ed0-294e-45a9-b1ef-2e02d5933c18" --no-sandbox
yes | npx @smithery/cli install mcp-pandoc --client vscode --key "08295ed0-294e-45a9-b1ef-2e02d5933c18" --no-sandbox
echo "===== MCP servers installation completed ====="

# Set up NAS connection
echo
echo "===== Setting up NAS connection ====="

sudo -v

save_credentials() {
  local smb_url="$1"
  local username="$2"
  local password="$3"

  if command -v secret-tool &> /dev/null; then
    echo -n "$password" | secret-tool store \
    --label="$username@$smb_url" \
    server "$smb_url" \
    user "$username" \
    domain "WORKGROUP" \
    protocol "smb" \
    xdg:schema "org.gnome.keyring.NetworkPassword"
    echo "Credentials saved to keyring for $smb_url"
  else
    echo "secret-tool not found. Cannot store credentials in keyring."
    echo "Install libsecret-tools package for keyring support."
  fi
}

add_bookmark() {
  local smb_url="$1"
  local bookmark_file="$HOME/.config/gtk-3.0/bookmarks"
  local name="NAS_${smb_url##*/}"  # Extract last path component

  mkdir -p "$HOME/.config/gtk-3.0"

  if grep -q " $smb_url\$" "$bookmark_file" 2>/dev/null; then
    sed -i "\| $smb_url\$|d" "$bookmark_file"
  fi

  echo "$smb_url $name" >> "$bookmark_file"
  echo "Bookmark added for $smb_url as '$name'"
}

nas_link=""
username=""
password=""

if command -v zenity &> /dev/null; then
  nas_link=$(zenity --entry --title="NAS Connection" --text="Enter NAS link (e.g., xxxxx.synology.me):" --width=300)
  username=$(zenity --entry --title="Authentication Required" --text="Enter username for Synology NAS:" --width=300)
  password=$(zenity --password --title="Authentication Required" --text="Enter password for $username:")
else
  read -p "Enter username for Synology NAS: " username
  read -s -p "Enter password for $username: " password
  echo
fi

if ! dpkg -l | grep -q "ii  libsecret-tools "; then
  echo "Installing libsecret-tools..."
  sudo apt update
  sudo apt install -y libsecret-tools
fi

save_credentials "$nas_link" "$username" "$password"
add_bookmark "smb://$nas_link/shared"
add_bookmark "smb://$nas_link/home"
echo "===== NAS connection setup completed ====="

# Set up color codes and bold text
RED='\033[0;31m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

# Gnome Settings
echo
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

# Set up terminator
echo
echo "===== Configuring Terminator settings ====="
mkdir -p $USER_HOME/.config/terminator
CONFIG_FILE="$USER_HOME/.config/terminator/config"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "[global_config]
[keybindings]
[profiles]
  [[default]]
    scrollback_infinite = True
[layouts]
[plugins]" > "$CONFIG_FILE"
    echo "infinite scrollback setting added to Terminator config."
else
    if ! grep -q "^\[profiles\]" "$CONFIG_FILE"; then
        echo -e "\n[profiles]\n  [[default]]\n    scrollback_infinite = True" >> "$CONFIG_FILE"
    else
        if ! grep -q "^\s*\[\[default\]\]" "$CONFIG_FILE"; then
            sed -i '/^\[profiles\]/a \  [[default]]\n    scrollback_infinite = True' "$CONFIG_FILE"
        else
            if grep -q "^\s*scrollback_infinite" "$CONFIG_FILE"; then
                sed -i 's/scrollback_infinite = .*/scrollback_infinite = True/g' "$CONFIG_FILE"
            else
                sed -i '/^\s*\[\[default\]\]/a \    scrollback_infinite = True' "$CONFIG_FILE"
            fi
        fi
    fi
fi
echo "===== Terminator configuration completed ====="

# System reboot option
echo
echo -e "\nAll setup tasks have been completed. System needs to be rebooted to apply changes."
read -p "Would you like to reboot now? (y/n): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "Please reboot manually when convenient."
fi
