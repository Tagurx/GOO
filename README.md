# Nexus Node Setup Script

This repository provides a shell script to automate the installation and registration of a Nexus node on a Debian/Ubuntu-based Linux system.

## What It Does

The script performs the following steps:

1. Updates and upgrades system packages
2. Installs required dependencies (build tools, SSL, Git, etc.)
3. Installs the Nexus CLI
4. Adds Nexus CLI to your system PATH
5. Registers a Nexus user with your wallet address
6. Registers a node with your node ID
7. Starts the Nexus node with your specified difficulty

---

## Setup Instructions

### 1. Clone this repository or download the script

### 2. Get Your Wallet Address and Node ID

### To obtain your wallet address and node ID, please visit https://nexus.xyz and sign up or sign in to your account.

```bash
git clone https://github.com/Tagurx/GOO.git
cd GOO
nano nexus-setup.sh

# Replace with your actual wallet address
nexus-cli register-user --wallet-address 0xYOUR_WALLET_ADDRESS

# Replace with your node ID
nexus-cli register-node --node-id YOUR_NODE_ID

# Set your preferred max difficulty: small | medium | large
nexus-cli start --max-difficulty YOUR_DIFFICULTY

# Save, and then make it an executable
chmod +x nexus-setup.sh

# Run
./nexus-setup.sh



