#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install build-essential pkg-config libssl-dev git-all -y

# Install Nexus CLI
curl https://cli.nexus.xyz/ | sh

# Manually add Nexus CLI to PATH for this script's environment
export PATH="$HOME/.nexus/bin:$PATH"

# Register user and node
nexus-cli register-user --wallet-address 0x5085243f33dF36719d2B2C50D67E1586DE000e88
nexus-cli register-node --node-id 36129520

# Start node
nexus-cli start --max-difficulty large
