BAB 1. BUSINESS PROCESS MUSTAHIQ
Tugas Utama

Mustahiq bertanggung jawab terhadap seluruh administrasi akademik kelas.

Meliputi:

Mengelola data kelas yang diampu.
Mengelola administrasi siswi.
Mengelola absensi harian siswi.
Mengelola penilaian sesuai SOP MPHM.
Menginput nilai Akhlaq.
Memeriksa kelengkapan seluruh nilai.
Mengajukan finalisasi nilai kelas.
Memeriksa hasil raport.
Memantau perkembangan akademik siswi.

Mustahiq tidak memiliki hak mengubah data master maupun rumus penilaian. Hal ini sesuai pembagian hak akses pada blueprint modul penilaian.

BAB 2. ALUR KERJA MUSTAHIQ
Login

↓

Dashboard

↓

Pilih Tahun Ajaran

↓

Pilih Semester

↓

Pilih Kelas

↓

Absensi Harian

↓

Input Nilai

↓

Input Akhlaq

↓

Periksa Kelengkapan

↓

Ajukan Finalisasi

↓

Menunggu Persetujuan Admin

↓

Lihat Raport

↓

Selesai
BAB 3. STRUKTUR MENU
Dashboard

Data Siswi

Absensi

Penilaian

Akhlaq

Raport

Prestasi (Al-Bayan)

Kalender Akademik

Pengumuman

Profil

Saya sengaja tidak menambahkan menu yang tidak memiliki fungsi operasional bagi Mustahiq.

BAB 4. UI FLOW

Contoh Dashboard

┌────────────────────────────┐

Assalamu'alaikum

UST. AHMAD

Kelas : III B

Semester : Genap

────────────────────────────

Jumlah Siswi

28

────────────────────────────

Absensi Hari Ini

27 Hadir

1 Bi Idzni

────────────────────────────

Status Nilai

92%

────────────────────────────

Finalisasi

BELUM

────────────────────────────

[ Data Siswi ]

[ Absensi ]

[ Penilaian ]

[ Raport ]

────────────────────────────

Pengumuman

────────────────────────────
BAB 5. MENU ABSENSI
Tujuan

Mencatat kehadiran harian.

Input

Tanggal

↓

Daftar Siswi

↓

Status

Hadir
Sakit
Bi Idzni
Bi Ghoirihi

↓

Catatan

↓

Simpan

Validasi

Tidak boleh:

kosong
ganda
tanggal sama dua kali
Rekap

Per Hari

Per Bulan

Per Semester

Data ini menjadi dasar perhitungan Akhlaq dan Prestasi sebagaimana dijelaskan pada blueprint penilaian.

BAB 6. MENU PENILAIAN

Inilah modul terbesar.

Saya akan memecahnya menjadi beberapa submodul.

6.1 Kuartal
Kuartal 1

↓

Tamrin Semester I

↓

Input Nilai

↓

Validasi

↓

Simpan
Form Input
Nahwu

□□□□□□□□□□□□□□

Aisyah

Nilai

[ 8.5 ]

Fatimah

Nilai

[ 7 ]

Khadijah

Nilai

[ kosong ]
Validasi

Input

0

↓

10

Tetapi

Al-Qur'an

maksimal

8

Akhlaq

maksimal

8

sesuai SOP.

Setelah Simpan

Sistem menghitung:

Jumlah Nilai Kuartal
Nilai Rata-rata Kuartal

Menggunakan mata pelajaran yang diperbolehkan sesuai ketentuan MPHM.

BAB 7. SEMESTER

Setelah Kuartal 1 & Kuartal 2 selesai.

Sistem otomatis:

Nilai Khos

↓

Pembulatan

↓

Status Raport

Mengikuti aturan pembulatan resmi.

BAB 8. FINALISASI

Sebelum Finalisasi.

Checklist otomatis.

✓ Semua nilai masuk

✓ Akhlaq lengkap

✓ Tidak ada data kosong

✓ Semua siswi aktif memiliki nilai

Jika masih ada yang belum lengkap.

Tombol

Finalisasi

berwarna abu.

Tidak bisa ditekan.

BAB 9. API

Contoh endpoint:

POST /login

GET /dashboard

GET /students

GET /attendance

POST /attendance

GET /grades

POST /grades

GET /akhlaq

POST /akhlaq

POST /class/finalize

GET /report

GET /prestasi
BAB 10. DATABASE

Tabel yang digunakan:

users

classes

students

attendance

subjects

grades

akhlaq

reports

prestasi

notifications

audit_logs
BAB 11. AUDIT LOG

Setiap aktivitas dicatat.

Contoh:

08:11

Mustahiq

Mengubah nilai Nahwu

Aisyah

8

↓

8.5
BAB 12. OFFLINE MODE

Saat internet terputus:

Input

↓

Disimpan Lokal

↓

Internet kembali

↓

Sinkronisasi

↓

Backend Cloudflare

Tidak ada data yang hilang.