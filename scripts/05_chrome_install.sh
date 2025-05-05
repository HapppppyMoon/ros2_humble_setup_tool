#!/bin/bash

# Google Chrome Installation Script

# Get parameters from parent script
REAL_USER="$1"
USER_HOME="$2"
SCRIPT_DIR="$3"

echo "===== Installing Google Chrome ====="
TARGET_VERSION="134.0.6998.88-1"
echo "Checking Google Chrome version"
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
        echo "Installing Google Chrome $TARGET_VERSION"
        wget https://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_${TARGET_VERSION}_amd64.deb
        sudo apt install -y ./google-chrome-stable_${TARGET_VERSION}_amd64.deb --allow-downgrades
        sudo rm google-chrome-stable_${TARGET_VERSION}_amd64.deb
        sudo apt-mark hold google-chrome-stable
    fi
else
    echo "Google Chrome is not installed. Installing version $TARGET_VERSION"
    wget https://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_${TARGET_VERSION}_amd64.deb
    sudo apt install -y ./google-chrome-stable_${TARGET_VERSION}_amd64.deb --allow-downgrades
    sudo rm google-chrome-stable_${TARGET_VERSION}_amd64.deb
    sudo apt-mark hold google-chrome-stable
fi
google-chrome
cd $USER_HOME
echo "===== Google Chrome installation completed ====="
