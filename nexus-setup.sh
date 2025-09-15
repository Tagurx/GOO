#!/bin/bash
set -euo pipefail  # Exit on error, unset var, or pipe failure
IFS=$'\n\t'

#-------------------------#
# 1. Update System        #
#-------------------------#
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

#-------------------------#
# 2. Prevent Config Prompts
#-------------------------#
echo "Setting apt to keep existing config files..."
sudo tee /etc/apt/apt.conf.d/local-keep-conf > /dev/null <<EOF
Dpkg::Options {
   "--force-confdef";
   "--force-confold";
};
EOF

#-------------------------#
# 3. Install Dependencies #
#-------------------------#
echo "Installing required packages..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y build-essential pkg-config libssl-dev git-all curl

#-------------------------#
# 4. Install Nexus CLI    #
#-------------------------#
NEXUS_CLI_PATH="$HOME/.nexus/bin/nexus-cli"

if [ ! -x "$NEXUS_CLI_PATH" ]; then
    echo "Installing Nexus CLI..."
    curl -s https://cli.nexus.xyz/ | sh

    if [ ! -x "$NEXUS_CLI_PATH" ]; then
        echo "Nexus CLI installation failed. Please check the install script or network connection."
        exit 1
    fi
else
    echo "Nexus CLI is already installed. Skipping installation."
fi

#-------------------------#
# 5. Update PATH          #
#-------------------------#
echo "Updating PATH environment variable..."

# Temporarily export for this session
export PATH="$HOME/.nexus/bin:$PATH"

# Persist in shell config (supports both bash and zsh)
add_to_profile() {
    local line='export PATH="$HOME/.nexus/bin:$PATH"'
    local profile_file="$1"
    if [ -f "$profile_file" ] && ! grep -Fxq "$line" "$profile_file"; then
        echo "$line" >> "$profile_file"
        echo "Added Nexus CLI to $profile_file"
    fi
}

add_to_profile "$HOME/.bashrc"
add_to_profile "$HOME/.zshrc"

#-------------------------#
# 6. Nexus Registration   #
#-------------------------#
echo "Registering Nexus user..."
nexus-cli register-user --wallet-address 0x5085243f33dF36719d2B2C50D67E1586DE000e88

echo "Registering Nexus node..."
nexus-cli register-node --node-id 36129520

#-------------------------#
# 7. Start Node           #
#-------------------------#
echo "Starting Nexus node..."
nexus-cli start --max-difficulty large

echo "Setup complete. Nexus CLI is ready to use."
