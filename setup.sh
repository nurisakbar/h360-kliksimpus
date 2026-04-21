#!/bin/bash

# setup.sh - Script untuk konfigurasi otomatis permissions dan membangun Docker

# 1. Deteksi UID dan GID user saat ini
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

echo "---[ Setup H360 Infrastructure ]---"
echo "Identitas User: UID=$CURRENT_UID, GID=$CURRENT_GID"

# 2. Cek apakah file .env ada
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✔ File .env dibuat dari .env.example"
    elif [ -f env.example ]; then
        cp env.example .env
        echo "✔ File .env dibuat dari env.example"
    else
        echo "Error: File .env tidak ditemukan!"
        exit 1
    fi
fi

# 3. Update HOST_UID dan HOST_GID di file .env menggunakan perl agar kompatibel Mac & Linux
# Kami menggunakan perl karena sed memiliki perbedaan sintaks yang signifikan antara Mac dan Linux
perl -i -pe "s/^HOST_UID=.*/HOST_UID=$CURRENT_UID/g" .env
perl -i -pe "s/^HOST_GID=.*/HOST_GID=$CURRENT_GID/g" .env

echo "✔ File .env telah diperbarui dengan UID/GID yang sesuai."

# 4. Pastikan folder data memiliki izin yang benar
echo "Memperbaiki izin folder .upload dan .database..."
mkdir -p .upload .database logs/sftpgo-ingest
chmod -R 755 .upload .database logs

# 5. Cek apakah Docker terinstall
if ! command -v docker &> /dev/null; then
    echo "Error: Perintah 'docker' tidak ditemukan. Pastikan Docker sudah terinstall."
    exit 1
fi

# 6. Jalankan Docker Build dan Up
echo "Membangun dan menjalankan container..."
docker compose pull
docker compose build
docker compose up -d

echo "------------------------------------"
echo "Selesai! Layanan seharusnya sudah berjalan."
echo "Dashboards: https://dashboards.kliksimpus.com"
echo "Upload: https://upload.kliksimpus.com"
