#!/bin/bash

# MATLAB Installation Script

# Get parameters from parent script
REAL_USER="$1"
USER_HOME="$2"
SCRIPT_DIR="$3"

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

proceed_with_installation=true

if check_matlab_installation; then
    echo "MATLAB appears to be already installed on this system."
    read -p "Do you want to proceed with installation anyway? (y/n): " answer

    # Convert to lowercase
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

    if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
        echo "Continuing with installation as requested"
    else
        echo "Installation cancelled by user. MATLAB is already installed."
        proceed_with_installation=false
    fi
else
    echo "MATLAB is not installed. Proceeding with installation"
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
        echo "Waiting for download to complete"
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
