#!/bin/bash

curl -s https://raw.githubusercontent.com/choir94/Airdropguide/refs/heads/main/logo.sh | bash
sleep 5

# Define colors for better output visibility
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Function for a cleaner header display
function print_header {
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${MAGENTA}           $1${NC}"
    echo -e "${CYAN}==============================================${NC}"
    echo ""
}

# Step 1: Get the latest version and download the executor release
print_header "Downloading Latest Executor Release"
echo -e "${GREEN}Fetching the latest version of the executor release...${NC}"
LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')

if [ -z "$LATEST_VERSION" ]; then
    echo -e "${RED}Error: Failed to fetch the latest release version.${NC}"
    exit 1
fi

DOWNLOAD_URL="https://github.com/t3rn/executor-release/releases/download/$LATEST_VERSION/executor-linux-$LATEST_VERSION.tar.gz"
echo -e "${GREEN}Latest version: ${LATEST_VERSION}${NC}"
echo -e "${GREEN}Downloading from: $DOWNLOAD_URL${NC}"

if ! wget -q "$DOWNLOAD_URL"; then
    echo -e "${RED}Error: Failed to download the latest release.${NC}"
    exit 1
fi
echo -e "${YELLOW}Download complete!${NC}\n"

# Step 2: Unzip the downloaded tarball
print_header "Unzipping the Executor Tarball"
echo -e "${GREEN}Unzipping executor-linux-${LATEST_VERSION}.tar.gz...${NC}"
if ! tar -xvzf "executor-linux-${LATEST_VERSION}.tar.gz"; then
    echo -e "${RED}Error: Failed to unzip the tarball.${NC}"
    exit 1
fi

# Clean up tarball
rm -f "executor-linux-${LATEST_VERSION}.tar.gz"
echo -e "${YELLOW}Unzip complete!${NC}\n"

# Step 3: Navigate to the executor/bin directory
print_header "Navigating to Executor Directory"
cd executor/executor/bin || { echo -e "${RED}Error: Directory not found.${NC}"; exit 1; }
echo -e "${YELLOW}Successfully navigated to executor/bin!${NC}\n"

# Step 4: Set environment variables
print_header "Setting Up Environment Variables"
echo -e "${GREEN}Configuring environment variables for execution...${NC}"
export NODE_ENV=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_ORDERS=true
export EXECUTOR_PROCESS_CLAIMS=true
export EXECUTOR_MAX_L3_GAS_PRICE=50
echo -e "${YELLOW}Environment variables set successfully!${NC}\n"

# Step 5: Set private key and enabled networks
print_header "Configuring Private Key and Networks"
echo -e "${GREEN}Please enter your private key (your input will not be shown):${NC}"
read -s PRIVATE_KEY
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
echo -e "${YELLOW}Private key and networks configured!${NC}\n"

# Step 6: Ensure the script runs inside a screen session
SESSION_NAME="airdropnode_t3rn"
print_header "Ensuring Executor Runs Inside a Screen Session"
if ! screen -list | grep -q "$SESSION_NAME"; then
    echo -e "${GREEN}No screen session found. Creating a new session named '$SESSION_NAME'...${NC}"
    screen -dmS $SESSION_NAME
    echo -e "${YELLOW}Screen session '$SESSION_NAME' created!${NC}\n"
else
    echo -e "${YELLOW}Screen session '$SESSION_NAME' already exists!${NC}\n"
fi

# Step 7: Run the executor inside the screen session
print_header "Running Executor Inside Screen Session"
echo -e "${BLUE}Starting executor in the screen session...${NC}"
screen -S $SESSION_NAME -X stuff "./executor\n"
echo -e "${YELLOW}Executor is now running inside the screen session '$SESSION_NAME'.${NC}\n"
