# Checklist Persiapan Hackathon (Sebelum 28 April)

Dokumen ini berisi daftar persiapan infrastruktur yang harus diselesaikan oleh tim DevOps sebelum hackathon dimulai.

## 1. Virtual Machine (VM)
- [x] OS: Amazon Linux 2023 atau Ubuntu 22.04 LTS. (Sudah jalan)
- [x] Spesifikasi Minimum: 2 vCPU, 4 GB RAM (e.g., AWS t3.medium). (Sudah jalan)
- [x] Akses SSH: Pastikan tim bisa login ke server menggunakan SSH. (Sudah jalan)
- [ ] Akses VM: Dapat diakses langsung oleh backend developer pada port `2121` dan `8090` (untuk FTP).

## 2. Instalasi Software
- [x] Git Terinstal.
- [x] Docker Terinstal dan berjalan.
- [x] Docker Compose Terinstal.
- [x] Docker Buildx Terinstal (Minimal versi `0.17.0`).

## 3. Konfigurasi Jaringan & Firewall (Security Groups)
Pastikan port berikut dikonfigurasi dengan benar:

| Resource | Port | Access / Source | Status |
| :--- | :--- | :--- | :--- |
| **Load Balancer** | 80 / 443 | Public (`0.0.0.0/0`) | [x] OK |
| **Server (EC2)** | 8080 & 3000 | Hanya dari Load Balancer | [x] OK |
| **Server (EC2)** | 22 (SSH) | Hanya IP Tim IT & Sistem EHR | [x] OK |
| **Server (EC2)** | 2121, 8090 | Hanya IP Sistem EHR | [ ] Pending |
| **Server (EC2)** | 50000 - 50100 | Hanya IP Sistem EHR (FTP Passive) | [ ] Pending |

## 4. Konfigurasi Load Balancer
Set up listener untuk mengarahkan traffic berdasarkan URL:
- [x] `upload.yourdomain.com` -> Forward ke port **8080** (Upload Service).
- [x] `dashboards.yourdomain.com` -> Forward ke port **3000** (Grafana Dashboards).
- [x] Pasang **SSL Certificate** pada Load Balancer untuk HTTPS. (Sudah aktif via nginx-proxy)

## 5. DNS Records
Buat CNAME record pada provider DNS (e.g., Route53, GoDaddy):
- [x] **Type:** `CNAME`, **Host:** `upload`, **Points to:** DNS name Load Balancer.
- [x] **Type:** `CNAME`, **Host:** `dashboards`, **Points to:** DNS name Load Balancer.

## 6. Verifikasi Akhir
Setelah deploy toolkit, pastikan hal berikut berfungsi:
- [x] Dashboard dapat diakses: `https://dashboards.kliksimpus.com` (TERKONFIRMASI)
- [ ] Endpoint FTP: Bisa terhubung ke port FTP server dari mesin eksternal.
- [x] Upload Portal (Opsional): `https://upload.kliksimpus.com` dapat diakses secara manual sebagai fallback.

---
**Catatan Penting:**
Infrastruktur inti sudah siap. Sisa item yang perlu diverifikasi adalah akses **FTP (port 2121, 8090, 50000-50100)** dari luar jaringan.
