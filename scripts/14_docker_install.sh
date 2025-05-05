#!/bin/bash

# Docker Installation Script

# Get parameters from parent script
REAL_USER="$1"
USER_HOME="$2"
SCRIPT_DIR="$3"

echo "===== Installing Docker ====="
echo "Installing for user: $REAL_USER"
echo "User home directory: $USER_HOME"

# Remove any old Docker installations
echo "Removing old Docker installations if they exist"
sudo apt remove -y docker docker-engine docker.io containerd runc

# Update package lists
sudo apt update -y

# Install prerequisites
echo "Installing prerequisites"
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common x11-apps

# Add Docker's official GPG key
echo "Adding Docker's official GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "Adding Docker repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package database with Docker packages
sudo apt update -y

# Install Docker Engine, containerd, and Docker Compose
echo "Installing Docker Engine"
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to the docker group to run Docker without sudo
echo "Adding user $REAL_USER to the docker group"
sudo usermod -aG docker $REAL_USER
echo "User $REAL_USER added to the docker group."
echo "You may need to log out and log back in for this to take effect."

# Start and enable Docker service
echo "Starting and enabling Docker service"
sudo systemctl start docker
sudo systemctl enable docker

# Test Docker installation
echo "Testing Docker installation"
sudo docker run --rm hello-world

# Configure NVIDIA Container Toolkit for GPU support in Docker
if lspci | grep -i nvidia > /dev/null; then
    echo "NVIDIA GPU detected. Installing NVIDIA Container Toolkit"

    # Install NVIDIA Container Toolkit (updated method)
    # Remove old NVIDIA Docker repository if it exists
    sudo rm -f /etc/apt/sources.list.d/nvidia-docker.list

    # Setup the NVIDIA Container Toolkit repository
    echo "Setting up the NVIDIA Container Toolkit repository"
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

    distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    # Update and install
    sudo apt-get update
    sudo apt-get install -y nvidia-container-toolkit

    # Configure the Docker daemon to use NVIDIA Container Toolkit
    echo "Configuring Docker daemon for NVIDIA Container Toolkit"
    sudo nvidia-ctk runtime configure --runtime=docker

    # Restart Docker daemon
    sudo systemctl restart docker

    # Test NVIDIA Docker support
    echo "Testing NVIDIA Docker support"
    sudo docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi || \
        sudo docker run --rm --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi

    echo "NVIDIA Container Toolkit configured successfully."
else
    echo "No NVIDIA GPU detected. Skipping NVIDIA Container Toolkit installation."
fi

# Update README.md in Features section to include Docker
if [ -n "$SCRIPT_DIR" ]; then
    README_PATH="$SCRIPT_DIR/../README.md"
    if [ -f "$README_PATH" ]; then
        echo "Updating README.md to include Docker installation information"
        sed -i '/- Docker environment setup script/a\ \ - Complete Docker CE installation with NVIDIA Container Toolkit support' "$README_PATH"
    fi
fi

echo "===== Docker installation completed ====="
