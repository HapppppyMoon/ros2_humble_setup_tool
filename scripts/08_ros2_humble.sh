#!/bin/bash

# ROS2 Humble Installation Script

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
