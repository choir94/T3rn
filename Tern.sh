#!/bin/bash

echo ""
echo "Join: https://t.me/airdrop_node"
read -p "Have you join t.me/airdrop_node on tele? (y/Y to proceed): " JOINED

if [[ ! "$JOINED" =~ ^[yY]$ ]]; then
    echo ""
    echo "Please join t.me/airdrop_node on tele before proceeding."
    exit 1
fi

cd $HOME
rm -rf executor
sudo apt -q update
sudo apt -qy upgrade

# Executor version
EXECUTOR_VERSION="v0.21.5"
EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/${EXECUTOR_VERSION}/executor-linux-${EXECUTOR_VERSION}.tar.gz"

# Step 1: Download Executor Binary
echo "Downloading Executor Binary..."
wget $EXECUTOR_URL -O executor.tar.gz

# Step 3: Extract Executor Binary
echo "Extracting Executor Binary..."
tar -xzvf executor.tar.gz
cd executor

# Step 4: Move binary to /usr/local/bin for system-wide access
echo "Moving Executor Binary to /usr/local/bin..."
sudo mv executor /usr/local/bin/

# Step 5: Set environment variables
echo "Configuring environment variables..."

# Prompt for Node Environment (default to testnet)
read -p "Please enter your NODE_ENV (default is 'testnet'): " NODE_ENV
NODE_ENV=${NODE_ENV:-testnet} # Default to testnet if no input
export NODE_ENV
echo "export NODE_ENV=$NODE_ENV" >> ~/.bashrc
echo "Node environment set to: $NODE_ENV"

# Set Log Settings
export LOG_LEVEL=debug
export LOG_PRETTY=false
echo "export LOG_LEVEL=debug" >> ~/.bashrc
echo "export LOG_PRETTY=false" >> ~/.bashrc
echo "Log settings: LOG_LEVEL=$LOG_LEVEL, LOG_PRETTY=$LOG_PRETTY"

# Step 6: Networks & RPC

# Set Enabled Networks
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
echo "export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'" >> ~/.bashrc
echo "Enabled networks: $ENABLED_NETWORKS"

# Optional: Add Custom RPC Endpoints
# Example: Replace with your own RPC URLs if needed
export RPC_ENDPOINTS_ARBT='https://url1.io,https://url2.io'
export RPC_ENDPOINTS_BSSP='https://url3.io,https://url4.io'
export RPC_ENDPOINTS_OPSP='https://url5.io,https://url6.io'
export RPC_ENDPOINTS_BLSS='https://url7.io,https://url8.io'

echo "export RPC_ENDPOINTS_ARBT='https://url1.io,https://url2.io'" >> ~/.bashrc
echo "export RPC_ENDPOINTS_BSSP='https://url3.io,https://url4.io'" >> ~/.bashrc
echo "export RPC_ENDPOINTS_OPSP='https://url5.io,https://url6.io'" >> ~/.bashrc
echo "export RPC_ENDPOINTS_BLSS='https://url7.io,https://url8.io'" >> ~/.bashrc

# Step 7: Prompt for Private Key input
read -sp "Please enter your PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL
echo ""
if [[ -z "$PRIVATE_KEY_LOCAL" ]]; then
    echo "Error: PRIVATE_KEY_LOCAL is not set. Exiting."
    exit 1
else
    echo "Private key received."
    # Export and save the private key to ~/.bashrc
    export PRIVATE_KEY_LOCAL
    echo "export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL" >> ~/.bashrc
    echo "Private key saved in environment variables."
fi

# Step 8: Start the Executor
echo "Starting the Executor..."
./executor &

# Source the updated bashrc
source ~/.bashrc

echo "Executor started successfully."
echo "Installation and setup complete."
