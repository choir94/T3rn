#!/bin/bash

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

# Cek jika direktori executor ada dan hapus jika ada
if [ -d "executor" ]; then
    print_warning "🔴 Direktori 'executor' ditemukan, menghapusnya terlebih dahulu..."
    rm -r executor
    if [ $? -ne 0 ]; then
        print_error "❌ Gagal menghapus direktori executor!"
        exit 1
    fi
    print_success "✅ Direktori 'executor' telah dihapus.\n"
else
    print_info "✅ Direktori 'executor' tidak ditemukan, melanjutkan...\n"
fi

# Mengunduh dan memverifikasi file executor
print_info "🔽 Mengunduh versi terbaru executor (v0.28.0)..."
wget https://github.com/t3rn/executor-release/releases/download/v0.28.0/executor-linux-v0.28.0.tar.gz -O executor-linux-v0.28.0.tar.gz
if [ $? -ne 0 ]; then
    print_error "❌ Unduhan gagal!"
    exit 1
fi
print_success "✅ Unduhan selesai!\n"

# Memverifikasi file arsip
print_info "📦 Memverifikasi file arsip..."
gzip -t executor-linux-v0.28.0.tar.gz
if [ $? -ne 0 ]; then
    print_error "❌ File arsip rusak!"
    exit 1
fi

# Mengekstrak arsip executor
print_info "📦 Mengekstrak arsip executor..."
tar -xvzf executor-linux-v0.28.0.tar.gz
if [ $? -ne 0 ]; then
    print_error "❌ Ekstraksi gagal!"
    exit 1
fi

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
screen -dmS airdropnode_t3rn ./executor
if [ $? -ne 0 ]; then
    print_error "❌ Gagal menjalankan executor di sesi screen 'airdropnode_t3rn'!"
    exit 1
fi
print_success "✅ Executor berhasil dijalankan di sesi screen 'airdropnode_t3rn'.\n"

# Menampilkan informasi
print_info "\n============================================="
print_success "🎉 Executor berjalan di latar belakang!"
print_info "Gunakan perintah berikut untuk melihat log:\n"
print_warning "    screen -r airdropnode_t3rn"
print_info "============================================="

# Masuk ke dalam sesi screen 'airdropnode_t3rn' secara otomatis
print_info "📲 Masuk ke dalam sesi screen 'airdropnode_t3rn'..."
screen -r airdropnode_t3rn
