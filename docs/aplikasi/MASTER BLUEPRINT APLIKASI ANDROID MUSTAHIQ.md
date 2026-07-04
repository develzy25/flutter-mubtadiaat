Baik. Mulai dari titik ini saya akan menyusun **Master Blueprint Mustahiq** yang nantinya menjadi acuan implementasi Flutter. Seluruh modul penilaian akan mengikuti dokumen MPHM yang Anda unggah, sedangkan bagian lain akan mengikuti SOP operasional Mustahiq tanpa menambahkan fitur yang tidak diperlukan. 

# MASTER BLUEPRINT

# APLIKASI ANDROID MUSTAHIQ

## BAB 1 — PENDAHULUAN

---

# 1.1 Latar Belakang

Administrasi Madrasah Putri Hidayatul Mubtadi'at selama ini masih dilakukan menggunakan buku administrasi dan formulir cetak sehingga:

* Pengisian nilai membutuhkan waktu lama.
* Rekap nilai dilakukan secara manual.
* Pemeriksaan nilai memerlukan banyak berkas.
* Risiko kesalahan penulisan cukup tinggi.
* Proses pencarian data membutuhkan waktu.
* Pembuatan raport memerlukan proses berulang.

Aplikasi Android Mustahiq dikembangkan untuk mendigitalisasi seluruh administrasi kelas tanpa mengubah SOP resmi MPHM.

---

# 1.2 Tujuan

Aplikasi bertujuan untuk:

* Mempermudah administrasi kelas.
* Mempermudah pencatatan absensi.
* Mempermudah pengelolaan nilai.
* Mengurangi kesalahan perhitungan.
* Mempercepat pembuatan raport.
* Menjaga konsistensi SOP MPHM.
* Terhubung langsung dengan sistem pusat.

---

# 1.3 Ruang Lingkup

Aplikasi hanya digunakan oleh:

**Mustahiq**

Aplikasi hanya mengelola:

* kelas yang diampu
* siswi pada kelas tersebut
* administrasi kelas

Mustahiq **tidak** dapat mengakses kelas lain.

---

# 1.4 Platform

Platform:

Android

Framework:

Flutter

Backend:

Cloudflare Workers + Hono

Database:

Cloudflare D1

Storage:

Cloudflare R2

Authentication:

JWT

Push Notification:

Firebase Cloud Messaging

---

# 1.5 Arsitektur

```text
Android Flutter

↓

Cloudflare API

↓

Business Logic

↓

Cloudflare D1

↓

Cloudflare R2

↓

Backup
```

---

# BAB 2 — PERMISSION MATRIX

| Modul      | Lihat | Tambah | Edit  | Hapus | Finalisasi |
| ---------- | :---: | :----: | :---: | :---: | :--------: |
| Dashboard  |   ✔   |   ✖    |   ✖   |   ✖   |     ✖      |
| Data Siswi |   ✔   |   ✖    |   ✖   |   ✖   |     ✖      |
| Absensi    |   ✔   |   ✔    |   ✔   |   ✖   |     ✖      |
| Penilaian  |   ✔   |   ✔    |   ✔   |   ✖   |     ✖      |
| Akhlaq     |   ✔   |   ✔    |   ✔   |   ✖   |     ✖      |
| Raport     |   ✔   |   ✖    |   ✖   |   ✖   |     ✖      |
| Prestasi   |   ✔   |   ✖    |   ✖   |   ✖   |     ✖      |
| Finalisasi |   ✔   |   ✔    |   ✖   |   ✖   |     ✔      |

---

# BAB 3 — DASHBOARD

## Tujuan

Memberikan informasi kondisi kelas secara real-time.

---

## Widget Dashboard

### Header

```
Assalamu'alaikum

Nama Mustahiq

Kelas

Semester

Tahun Ajaran
```

---

### Ringkasan

Card 1

Jumlah Siswi Aktif

---

Card 2

Jumlah Siswi Mutasi

---

Card 3

Absensi Hari Ini

---

Card 4

Status Nilai

---

Card 5

Status Finalisasi

---

Card 6

Notifikasi

---

### Quick Action

* Input Absensi
* Input Nilai
* Input Akhlaq
* Lihat Raport
* Finalisasi

---

### Kalender Hari Ini

Menampilkan:

* Tamrin
* Ujian
* Libur
* Agenda

---

### Pengumuman

Menampilkan maksimal 10 pengumuman terbaru.

---

# BAB 4 — DATA SISWI

## Tujuan

Menampilkan seluruh informasi akademik siswi.

---

## List Siswi

Kolom:

* Foto
* NIS
* Nama
* Status

Filter:

* Aktif
* Mutasi
* Alumni

Pencarian:

* Nama
* NIS

---

## Detail Siswi

### Identitas

* Foto
* NIS
* NISN
* Nama
* Tempat Lahir
* Tanggal Lahir
* Nama Ayah
* Nama Ibu
* Wali
* Nomor HP
* Alamat

---

### Akademik

* Tahun Ajaran
* Semester
* Kelas

---

### Statistik

* Jumlah Hadir
* Bi Idzni
* Bi Ghoirihi
* Sakit

---

### Nilai

Per Semester

Per Kuartal

---

### Riwayat

* Raport
* Prestasi
* Al-Bayan

---

# BAB 5 — ABSENSI

Ini bukan hanya daftar hadir.

Tetapi menjadi sumber data:

* Akhlaq
* Prestasi
* Raport

sesuai ketentuan MPHM. 

---

## Halaman Absensi

Header

Tanggal

↓

Kelas

↓

Jumlah Siswi

---

## Daftar Siswi

Untuk setiap siswi

```
Foto

Nama

○ Hadir

○ Sakit

○ Bi Idzni

○ Bi Ghoirihi
```

---

## Tombol

Simpan

Reset

Pilih Semua Hadir

---

## Validasi

Tidak boleh:

* dua status
* kosong
* tanggal ganda

---

## Setelah Simpan

Backend akan:

* memperbarui rekap semester
* memperbarui statistik absensi
* memperbarui perhitungan Akhlaq

---

# BAB 6 — PENILAIAN

Blueprint modul ini akan dibuat paling rinci karena menjadi inti aplikasi. Seluruh aturan mengenai kuartal, Nilai Khos, Nilai 'Am, pembulatan, finalisasi, dan Prestasi akan mengikuti blueprint resmi MPHM yang telah Anda berikan. 

---

Saya menyarankan agar **BAB 6 — Penilaian** dibuat sebagai dokumen tersendiri sekitar **150–200 halaman Markdown**, karena di dalamnya akan diuraikan hingga tingkat implementasi, meliputi:

* Semua halaman input Kuartal 1–4.
* Form input nilai setiap mata pelajaran.
* Validasi setiap jenis nilai.
* Perhitungan otomatis Nilai Khos.
* Perhitungan Nilai 'Am.
* Perhitungan Prestasi (Al-Bayan).
* Pengaruh absensi terhadap Akhlaq dan Prestasi.
* Proses Finalisasi Nilai Kelas.
* Wireframe UI setiap halaman.
* Struktur tabel database terkait penilaian.
* Endpoint API lengkap beserta request/response.
* Audit log perubahan nilai.
* Penanganan kondisi khusus (Her, nilai kosong, mutasi, dll.) sesuai SOP MPHM. 

Dengan cara ini, blueprint tidak hanya menjadi dokumentasi, tetapi benar-benar dapat dijadikan pedoman implementasi tanpa perlu menebak kebutuhan sistem.
