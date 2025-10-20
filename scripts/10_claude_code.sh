#!/bin/bash

# Claude Code Installation Script

echo "===== Installing Claude Code ====="

# Get latest nvm version from GitHub API
echo "Fetching latest nvm version..."
NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$NVM_VERSION" ]; then
    echo "Failed to fetch latest nvm version. Using fallback version v0.40.3"
    NVM_VERSION="v0.40.3"
fi

echo "Installing nvm ${NVM_VERSION}..."

# Download and install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# Load nvm (in lieu of restarting the shell)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Download and install Node.js LTS
echo "Installing Node.js LTS..."
nvm install --lts

# Set the installed LTS version as default
nvm alias default 'lts/*'

# Verify Node.js installation
echo "Node.js version:"
node -v

# Verify npm installation
echo "npm version:"
npm -v

# Install Claude Code
echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "===== Claude Code installation completed ====="
echo "You can now use 'claude' command to run Claude Code"
