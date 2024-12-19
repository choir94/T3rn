#!/bin/bash

# Install figlet
print_info "🔽 Installing figlet..."
sudo apt-get install -y figlet
if [ $? -ne 0 ]; then
    print_error "❌ Gagal menginstal figlet!"
    exit 1
fi
print_success "✅ figlet terinstal.\n"

# Display the Star Wars font
print_info "🎉 Menampilkan teks dengan font Star Wars..."
figlet -f /usr/share/figlet/starwars.flf "Airdrop Node"
if [ $? -ne 0 ]; then
    print_error "❌ Gagal menampilkan teks dengan figlet!"
    exit 1
fi
print_success "✅ Teks berhasil ditampilkan!\n"

curl -s https://raw.githubusercontent.com/choir94/Airdropguide/refs/heads/main/logo.sh | bash
sleep 5

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

# Mendapatkan versi terbaru dari release executor
print_info "🔽 Mendapatkan versi terbaru dari executor..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep 'tag_name' | cut -d\" -f4)
if [ -z "$LATEST_VERSION" ]; then
    print_error "❌ Gagal mendapatkan versi terbaru!"
    exit 1
fi
print_success "✅ Versi terbaru: v$LATEST_VERSION\n"

# Mengunduh file executor
print_info "🔽 Mengunduh executor versi $LATEST_VERSION..."
EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/${LATEST_VERSION}/executor-linux-${LATEST_VERSION}.tar.gz"
curl -L -o executor-linux-${LATEST_VERSION}.tar.gz $EXECUTOR_URL
if [ $? -ne 0 ]; then
    print_error "❌ Unduhan gagal!"
    exit 1
fi
print_success "✅ Unduhan selesai!\n"

# Mengekstrak arsip executor
print_info "📦 Mengekstrak arsip executor..."
tar -xzvf executor-linux-${LATEST_VERSION}.tar.gz
if [ $? -ne 0 ]; then
    print_error "❌ Ekstraksi gagal!"
    exit 1
fi
rm -rf executor-linux-${LATEST_VERSION}.tar.gz
print_success "✅ Ekstraksi selesai!\n"

# Navigasi ke direktori executor
print_info "📂 Navigasi ke direktori executor..."
cd executor || { print_error "❌ Direktori executor tidak ditemukan!"; exit 1; }
print_success "✅ Berada di direktori executor\n"

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

# Mengatur jaringan yang diaktifkan
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false

# Menjalankan executor di dalam sesi screen bernama 'airdropnode_t3rn'
print_info "🚀 Menjalankan executor di dalam sesi screen bernama 'airdropnode_t3rn'...\n"
screen -dmS airdropnode_t3rn ./executor && print_success "✅ Executor berhasil dijalankan di sesi screen 'airdropnode_t3rn'." || print_error "❌ Gagal menjalankan executor!"

# Menampilkan informasi
print_info "\n============================================="
print_success "🎉 Executor berjalan di latar belakang!"
print_info "Gunakan perintah berikut untuk melihat log:\n"
print_warning "    screen -r airdropnode_t3rn"
print_info "============================================="
