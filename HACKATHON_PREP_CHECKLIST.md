# Checklist Persiapan Hackathon (Sebelum 28 April)

Dokumen ini berisi daftar persiapan infrastruktur yang harus diselesaikan oleh tim DevOps sebelum hackathon dimulai.

## 1. Virtual Machine (VM)
- [ ] OS: Amazon Linux 2023 atau Ubuntu 22.04 LTS.
- [ ] Spesifikasi Minimum: 2 vCPU, 4 GB RAM (e.g., AWS t3.medium).
- [ ] Akses SSH: Pastikan tim bisa login ke server menggunakan SSH.
- [ ] Akses VM: Dapat diakses langsung oleh backend developer pada port `2121` dan `8090` (untuk FTP).

## 2. Instalasi Software
- [ ] Git Terinstal.
- [ ] Docker Terinstal dan berjalan.
- [ ] Docker Compose Terinstal.
- [ ] Docker Buildx Terinstal (Minimal versi `0.17.0`).

## 3. Konfigurasi Jaringan & Firewall (Security Groups)
Pastikan port berikut dikonfigurasi dengan benar:

| Resource | Port | Access / Source |
| :--- | :--- | :--- |
| **Load Balancer** | 80 / 443 | Public (`0.0.0.0/0`) |
| **Server (EC2)** | 8080 & 3000 | Hanya dari Load Balancer |
| **Server (EC2)** | 22 (SSH) | Hanya IP Tim IT & Sistem EHR |
| **Server (EC2)** | 2121, 8090 | Hanya IP Sistem EHR |
| **Server (EC2)** | 50000 - 50100 | Hanya IP Sistem EHR (FTP Passive) |

## 4. Konfigurasi Load Balancer
Set up listener untuk mengarahkan traffic berdasarkan URL:
- [ ] `upload.yourdomain.com` -> Forward ke port **8080** (Upload Service).
- [ ] `dashboards.yourdomain.com` -> Forward ke port **3000** (Grafana Dashboards).
- [ ] (Sangat Disarankan) Pasang **SSL Certificate** pada Load Balancer untuk HTTPS.

## 5. DNS Records
Buat CNAME record pada provider DNS (e.g., Route53, GoDaddy):
- [ ] **Type:** `CNAME`, **Host:** `upload`, **Points to:** DNS name Load Balancer.
- [ ] **Type:** `CNAME`, **Host:** `dashboards`, **Points to:** DNS name Load Balancer.

## 6. Verifikasi Akhir
Setelah deploy toolkit, pastikan hal berikut berfungsi:
- [ ] Dashboard dapat diakses: `http://dashboards.yourdomain.com`
- [ ] Endpoint FTP: Bisa terhubung ke port FTP server dari mesin eksternal.
- [ ] Upload Portal (Opsional): `http://upload.yourdomain.com` dapat diakses secara manual sebagai fallback.

---
**Catatan Penting:**
Pastikan infrastruktur siap sebelum **27 April**. Jika ada pertanyaan, hubungi `veluri@rtsl.org`.
