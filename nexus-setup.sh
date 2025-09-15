#!/bin/bash
set -e  # Exit on any error

# Update and upgrade system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Avoid configuration prompts during apt installs
echo "Preventing config prompts..."
echo 'Dpkg::Options {
   "--force-confdef";
   "--force-confold";
};' | sudo tee /etc/apt/apt.conf.d/local-keep-conf > /dev/null

# Install required packages silently
echo "Installing required packages..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y build-essential pkg-config libssl-dev git-all curl

# Install Nexus CLI using 'yes' to auto-confirm prompts
if [ ! -x "$HOME/.nexus/bin/nexus-cli" ]; then
    echo "Installing Nexus CLI..."
    yes | curl -s https://cli.nexus.xyz/ | sh
else
    echo "Nexus CLI is already installed. Skipping installation."
fi

# Add Nexus CLI to PATH for this script
export PATH="$HOME/.nexus/bin:$PATH"

# Optional: Add to ~/.bashrc for persistence
if ! grep -q 'export PATH="$HOME/.nexus/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/.nexus/bin:$PATH"' >> ~/.bashrc
fi

# Register Nexus user
echo "Registering user..."
nexus-cli register-user --wallet-address 0x5085243f33dF36719d2B2C50D67E1586DE000e88

# Register node
echo "Registering node..."
nexus-cli register-node --node-id 36129520

# Start node
echo "Starting Nexus node..."
nexus-cli start --max-difficulty large
