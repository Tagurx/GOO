#!/bin/bash
set -e

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Avoid config prompts during apt installs
echo 'Dpkg::Options {
   "--force-confdef";
   "--force-confold";
};' | sudo tee /etc/apt/apt.conf.d/local-keep-conf > /dev/null

# Install required packages silently
sudo DEBIAN_FRONTEND=noninteractive apt install build-essential pkg-config libssl-dev git-all -y

curl -s https://cli.nexus.xyz/ | sh <<EOF
y
EOF


# Manually add Nexus CLI to PATH for this script's environment
export PATH="$HOME/.nexus/bin:$PATH"

# Register user and node
nexus-cli register-user --wallet-address 0x5085243f33dF36719d2B2C50D67E1586DE000e88
nexus-cli register-node --node-id 36129520

# Start node
nexus-cli start --max-difficulty large
