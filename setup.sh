#!/bin/bash

# setup.sh - Script untuk konfigurasi otomatis permissions dan membangun Docker

# 1. Deteksi UID dan GID user saat ini
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

echo "---[ Setup H360 Infrastructure ]---"
echo "Identitas User: UID=$CURRENT_UID, GID=$CURRENT_GID"

# 2. Cek apakah file .env ada
if [ ! -f .env ]; then
    echo "Error: File .env tidak ditemukan! Silakan salin dari .env.example terlebih dahulu."
    exit 1
fi

# 3. Update HOST_UID dan HOST_GID di file .env
# Menggunakan sed untuk mencari dan mengganti nilai atau menambahkannya jika tidak ada
if grep -q "HOST_UID=" .env; then
    sed -i.bak "s/^HOST_UID=.*/HOST_UID=$CURRENT_UID/" .env
else
    echo "HOST_UID=$CURRENT_UID" >> .env
fi

if grep -q "HOST_GID=" .env; then
    sed -i.bak "s/^HOST_GID=.*/HOST_GID=$CURRENT_GID/" .env
else
    echo "HOST_GID=$CURRENT_GID" >> .env
fi

echo "✔ File .env telah diperbarui dengan UID/GID yang sesuai."

# 4. Pastikan folder data memiliki izin yang benar
echo "Memperbaiki izin folder .upload dan .database..."
mkdir -p .upload .database logs/sftpgo-ingest
chmod -R 755 .upload .database logs

# 5. Jalankan Docker Build dan Up
echo "Membangun dan menjalankan container..."
/usr/local/bin/docker compose pull
/usr/local/bin/docker compose build
/usr/local/bin/docker compose up -d

echo "------------------------------------"
echo "Selesai! Layanan seharusnya sudah berjalan."
echo "Dashboards: https://dashboards.kliksimpus.com"
echo "Upload: https://upload.kliksimpus.com"
