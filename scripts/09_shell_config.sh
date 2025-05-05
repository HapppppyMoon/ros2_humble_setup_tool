#!/bin/bash

# Shell Script Creation and .bashrc Configuration Script

# Get parameters from parent script
REAL_USER="$1"
USER_HOME="$2"
SCRIPT_DIR="$3"

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
echo "===== Creating shell scripts and configuring .bashrc completed ====="
