#!/bin/bash

# Function to print the introduction
print_intro() {
  # Check if figlet is installed, and install if missing
  if ! command -v figlet &> /dev/null; then
    echo "Figlet not found. Installing figlet..."
    sudo apt-get install figlet -y
  fi

  echo -e "\033[94m"
  figlet -f /usr/share/figlet/starwars.flf "T3Rn Executor"
  echo -e "\033[0m"


  echo "════════════════════════════════════════════════════════════"
  echo "║     Update Informasi Node Join ke telegram:         ║"
  echo "║     Telegram:                                            ║"
  echo "║     - https://t.me/airdrop_node                     ║"
  echo "╚════════════════════════════════════════════════════════════"

  # Prompt for user confirmation
  read -p "$(echo -e '\033[91mDo you want to proceed with T3Rn Airdrop? (Y/N): \033[0m')" answer  # Red color for the prompt
  if [[ "$answer" != "Y" && "$answer" != "y" ]]; then
    echo -e "\033[91mInstallation aborted.\033[0m"  # Red color for abort message
    exit 1
  fi
}

# Run the introduction function
print_intro

# Continue with the original script

cd $HOME
rm -rf executor
sudo apt -q update
sudo apt -qy upgrade

# Ensure the URL and the file version match
EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/v0.21.5/executor-linux-v0.21.5.tar.gz"
EXECUTOR_FILE="executor-linux-v0.21.5.tar.gz"

echo "Retrieving the Executor binary from $EXECUTOR_URL..."
curl -L -o $EXECUTOR_FILE $EXECUTOR_URL

if [ $? -ne 0 ]; then
    echo "Unable to download the Executor binary."
    exit 1
fi

echo "Unpacking the binary..."
tar -xzvf $EXECUTOR_FILE

if [ $? -ne 0 ]; then
    echo "Extraction failed. Please check the tarball format."
    exit 1
fi

rm -rf $EXECUTOR_FILE

# Ensure the directory exists before trying to cd
if [ ! -d "executor/executor/bin" ]; then
    echo "Directory executor/executor/bin not found after extraction."
    exit 1
fi

cd executor/executor/bin

echo "The binary has been successfully downloaded and unpacked."
echo

read -p "Please specify your desired Node Environment (e.g., testnet, mainnet): " NODE_ENV
export NODE_ENV=${NODE_ENV:-testnet}
echo "Node Environment is set to: $NODE_ENV"
echo

export LOG_LEVEL=debug
export LOG_PRETTY=false
echo "Log configuration set: LOG_LEVEL=$LOG_LEVEL, LOG_PRETTY=$LOG_PRETTY"
echo

read -s -p "Input your Metamask Private Key: " PRIVATE_KEY_LOCAL
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL
echo -e "\nPrivate key has been configured."
echo

read -p "Specify the networks you wish to operate on (comma-separated, e.g., arbitrum-sepolia,base-sepolia): " ENABLED_NETWORKS
export ENABLED_NETWORKS=${ENABLED_NETWORKS:-arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn}
echo "Networks activated: $ENABLED_NETWORKS"
echo

read -p "Would you like to configure custom RPC URLs? (y/n): " SET_RPC
if [ "$SET_RPC" == "y" ]; then
  for NETWORK in $(echo $ENABLED_NETWORKS | tr "," "\n"); do
    read -p "Enter the RPC URLs for $NETWORK (comma-separated): " RPC_URLS
    export EXECUTOR_${NETWORK^^}_RPC_URLS=$RPC_URLS
    echo "Custom RPC URLs set for $NETWORK"
  done
else
  echo "Custom RPC URL setup skipped. Default URLs will be used."
fi
echo

echo "Launching the Executor..."
./executor
echo -e "${BOLD_PINK} Join airdrop node https://t.me/airdrop_node ${RESET_COLOR}"

