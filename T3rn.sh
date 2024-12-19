#!/bin/bash

# Warna ANSI untuk output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fungsi untuk menampilkan pesan dengan warna
function print_info {
    echo -e "${CYAN}$1${NC}"
}

function print_success {
    echo -e "${GREEN}$1${NC}"
}

function print_warning {
    echo -e "${YELLOW}$1${NC}"
}

function print_error {
    echo -e "${RED}$1${NC}"
}

clear

print_info "============================================="
print_info "       🚀 Script dari Airdrop Node"
print_info "=============================================\n"

print_info "🔗 Join Telegram untuk informasi lebih lanjut:"
print_warning "    https://t.me/airdrop_node\n"

print_info "🔍 Mendeteksi versi terbaru dari GitHub..."

# Mengambil URL rilis terbaru dari GitHub API
LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep "browser_download_url.*executor-linux" | cut -d '"' -f 4)

if [ -z "$LATEST_RELEASE_URL" ]; then
    print_error "❌ Gagal mendeteksi rilis terbaru!"
    exit 1
else
    print_success "✅ Versi terbaru ditemukan: $LATEST_RELEASE_URL\n"
fi

# Nama file arsip unduhan
FILE_NAME="executor-linux-v0.28.0.tar.gz"

# Mengunduh rilis terbaru
print_info "🔽 Mengunduh executor versi terbaru..."
wget "$LATEST_RELEASE_URL" -O $FILE_NAME && print_success "✅ Unduhan selesai!\n" || { print_error "❌ Unduhan gagal!"; exit 1; }

# Mengekstrak arsip
print_info "📦 Mengekstrak arsip executor..."
tar -xvzf $FILE_NAME && print_success "✅ Ekstraksi selesai!\n" || { print_error "❌ Ekstraksi gagal!"; exit 1; }

# Navigasi ke direktori executor/bin
print_info "📂 Navigasi ke direktori executor/bin..."
cd executor/executor/bin || { print_error "❌ Direktori tidak ditemukan!"; exit 1; }
print_success "✅ Berada di direktori executor/bin\n"

# Mengatur variabel lingkungan
print_info "⚙️  Mengatur variabel lingkungan...\n"
export NODE_ENV=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_ORDERS=true
export EXECUTOR_PROCESS_CLAIMS=true
export EXECUTOR_MAX_L3_GAS_PRICE=50
print_success "✅ Variabel lingkungan telah diatur.\n"

# Meminta input private key dari pengguna
print_warning "🔑 Masukkan Private Key Anda dengan hati-hati!"
read -sp "Private Key: " PRIVATE_KEY
echo ""
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY
print_success "✅ Private Key disimpan.\n"

export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false

# Menjalankan executor di dalam sesi screen
print_info "🚀 Menjalankan executor di dalam sesi screen bernama 'airdropnode_t3rn'...\n"
screen -dmS airdropnode_t3rn ./executor && print_success "✅ Executor berhasil dijalankan di sesi screen 'airdropnode_t3rn'." || print_error "❌ Gagal menjalankan executor!"

print_info "\n============================================="
print_success "🎉 Executor berjalan di latar belakang!"
print_info "Gunakan perintah berikut untuk melihat log:\n"
print_warning "    screen -r airdropnode_t3rn"
print_info "=============================================\n"

print_info "🔗 Jangan lupa join Telegram Airdrop Node:"
print_warning "    https://t.me/airdrop_node"
