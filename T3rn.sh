#!/bin/bash

echo "=============================================="
echo "   🛠  t3rn Executor By Airdrop Node 🚀   "
echo "=============================================="
echo ""

# Meminta user memasukkan private key secara aman
read -sp "🔑 Masukkan Private Key Metamask Anda: " PRIVATE_KEY
echo ""
echo "✅ Private Key diterima!"
echo ""

# Perbarui sistem dan instal dependensi
echo "📦 Mengupdate sistem dan menginstal dependensi..."
sudo apt update && sudo apt install -y build-essential git screen
echo "✅ Instalasi dependensi selesai!"
echo ""

# Membuat sesi screen
echo "🖥  Membuat sesi screen bernama 't3rn'..."
screen -dmS t3rn bash -c '

# Download dan ekstrak executor
echo "📥 Mengunduh t3rn Executor..."
wget https://github.com/t3rn/executor-release/releases/download/v0.47.0/executor-linux-v0.47.0.tar.gz
tar -xvzf executor-linux-v0.47.0.tar.gz
cd executor/executor/bin

# Menampilkan pesan konfigurasi
echo "⚙️  Mengatur konfigurasi node..."

# Set variabel lingkungan
export NODE_ENV=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false

export EXECUTOR_PROCESS_ORDERS=true
export EXECUTOR_PROCESS_CLAIMS=true

# Gunakan Private Key dari input pengguna
export PRIVATE_KEY_LOCAL="'$PRIVATE_KEY'"

export ENABLED_NETWORKS="base-sepolia,optimism-sepolia,l1rn,blast-sepolia,arb-sepolia"
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
export EXECUTOR_PROCESS_ORDERS_API_ENABLED=false
export EXECUTOR_ENABLE_BATCH_BIDING=true
export EXECUTOR_PROCESS_BIDS_ENABLED=true
export EXECUTOR_MAX_L3_GAS_PRICE=5000

export RPC_ENDPOINTS_bssp="https://base-sepolia-rpc.publicnode.com/"
export RPC_ENDPOINTS_opsp="https://sepolia.optimism.io/"
export API_ENDPOINTS_L1RN="https://brn.rpc.caldera.xyz/"
export RPC_ENDPOINTS_blast="https://sepolia.blast.io/"
export RPC_ENDPOINTS_arb="https://arbitrum-sepolia-rpc.publicnode.com/"

# Menjalankan executor
echo "🚀 Menjalankan t3rn Executor..."
./executor
'

echo ""
echo "🎉 t3rn Executor Node telah berjalan!"
echo "🛠  Gunakan 'screen -r t3rn' untuk melihat log"
echo "📢 Gabung ke Telegram Airdrop Node untuk update terbaru!"
echo ""
