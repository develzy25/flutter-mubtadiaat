# BLUEPRINT 02 — APLIKASI ANDROID MUFATISH

## Tujuan

Aplikasi Mufatish merupakan aplikasi Android yang digunakan oleh Mufatish sebagai pengawas akademik dan operasional. Fokus utama aplikasi ini adalah melakukan monitoring, pemeriksaan, validasi, evaluasi, serta memberikan persetujuan terhadap data yang diinput oleh Mustahiq.

Mufatish **tidak melakukan administrasi sistem**, tetapi berperan sebagai pengawas yang memastikan seluruh proses pendidikan berjalan sesuai ketentuan pondok.

---

# Hak Akses

Role:

* Mufatish

Setelah login, Mufatish hanya dapat mengakses data sesuai wilayah, jenjang, atau unit yang menjadi tanggung jawabnya.

---

# Dashboard

Halaman utama menampilkan ringkasan kondisi seluruh kelas yang diawasi.

Menampilkan:

* Ucapan Selamat Datang
* Nama Mufatish
* Wilayah/Unit Tugas
* Jumlah Kelas
* Jumlah Mustahiq
* Jumlah Santri
* Absensi Hari Ini
* Persentase Kehadiran
* Rekap Nilai Masuk
* Penilaian Belum Lengkap
* Tamrin Berjalan
* Pengumuman
* Notifikasi
* Kalender Akademik

---

# Menu Utama

## 1. Dashboard

Ringkasan seluruh aktivitas pengawasan.

---

## 2. Monitoring Kelas

Menampilkan seluruh kelas.

Informasi:

* Nama Kelas
* Mustahiq
* Jumlah Santri
* Kehadiran Hari Ini
* Status Penilaian
* Status Tamrin
* Status Administrasi

Fitur:

* Cari kelas
* Filter
* Detail kelas

---

## 3. Monitoring Santri

Melihat seluruh santri.

Informasi:

* Biodata
* Kelas
* Status Aktif
* Absensi
* Nilai
* Pelanggaran
* Prestasi
* Catatan

Tidak dapat mengubah data kecuali diberi hak khusus oleh Admin.

---

## 4. Monitoring Absensi

Melihat absensi seluruh kelas.

Fitur:

* Rekap Harian
* Rekap Bulanan
* Persentase Kehadiran
* Grafik Kehadiran
* Daftar Santri Sering Tidak Hadir

---

## 5. Monitoring Penilaian

Melihat perkembangan pengisian nilai.

Menampilkan:

* Mata Pelajaran
* Kuartal
* Status Lengkap
* Status Belum Lengkap
* Ranking
* Nilai Tertinggi
* Nilai Terendah
* Nilai Rata-rata

---

## 6. Validasi Nilai

Melakukan pemeriksaan hasil input.

Fitur:

* Lihat Detail Nilai
* Bandingkan Antar Kuartal
* Berikan Catatan
* Setujui
* Tolak
* Kembalikan ke Mustahiq untuk diperbaiki

---

## 7. Monitoring Akhlak

Melihat perkembangan akhlak seluruh santri.

Komponen:

* Disiplin
* Adab
* Kebersihan
* Kejujuran
* Tanggung Jawab
* Kerapian

---

## 8. Monitoring Al-Qur'an

Menampilkan perkembangan:

* Tahsin
* Tahfidz
* Tajwid
* Hafalan
* Kelulusan Target

---

## 9. Monitoring Pelanggaran

Melihat seluruh pelanggaran.

Fitur:

* Filter
* Statistik
* Detail
* Riwayat Pelanggaran
* Tingkat Pelanggaran

---

## 10. Monitoring Prestasi

Menampilkan seluruh prestasi santri.

---

## 11. Monitoring Tamrin

Menampilkan:

* Jadwal Tamrin
* Peserta
* Nilai
* Hasil
* Kelulusan
* Catatan Penguji

---

## 12. Approval

Halaman persetujuan data.

Meliputi:

* Nilai
* Absensi
* Tamrin
* Data Santri (jika ada perubahan)
* Laporan Mustahiq

Status:

* Menunggu
* Disetujui
* Ditolak
* Perlu Revisi

---

## 13. Laporan

Menampilkan laporan akademik.

Meliputi:

* Rekap Kehadiran
* Rekap Nilai
* Rekap Akhlak
* Rekap Al-Qur'an
* Rekap Pelanggaran
* Rekap Prestasi
* Rekap Tamrin

---

## 14. Kalender Akademik

Menampilkan:

* Jadwal Ujian
* Jadwal Tamrin
* Libur Pondok
* Agenda Pendidikan
* Kegiatan Pondok

---

## 15. Pengumuman

Melihat seluruh pengumuman dari Admin.

---

## 16. Notifikasi

Berisi:

* Penilaian Menunggu Validasi
* Absensi Belum Lengkap
* Jadwal Tamrin
* Pengumuman Baru
* Deadline Administrasi

---

## 17. Profil

Berisi:

* Data Diri
* Foto
* Nomor HP
* Email
* Jabatan
* Wilayah Tugas
* Ubah Password

---

## 18. Bantuan

Berisi:

* Panduan Penggunaan
* FAQ
* Hubungi Admin

---

# Fitur Pengawasan

* Monitoring seluruh kelas dalam wilayah tugas.
* Validasi nilai sebelum diproses menjadi rapor.
* Memberikan catatan perbaikan kepada Mustahiq.
* Menyetujui atau menolak data.
* Melihat statistik akademik secara real-time.
* Riwayat seluruh proses validasi terdokumentasi (audit trail).

---

# Hak Akses

Mufatish **dapat**:

* Melihat seluruh data dalam wilayah tugas.
* Memberikan validasi.
* Memberikan catatan.
* Menyetujui atau menolak data.
* Melihat laporan dan statistik.

Mufatish **tidak dapat**:

* Menghapus data master.
* Mengubah konfigurasi sistem.
* Menambah pengguna.
* Mengubah struktur kurikulum.
* Mengubah rumus penilaian.
* Mengelola database.

---

# Validasi Sistem

* Semua proses persetujuan dicatat pada log aktivitas.
* Setiap penolakan wajib disertai alasan.
* Riwayat revisi tersimpan.
* Tidak dapat memvalidasi data yang belum lengkap.
* Sinkronisasi otomatis dengan backend Cloudflare.
* Setiap approval menggunakan timestamp dan identitas pengguna sebagai jejak audit.

Blueprint ini mendefinisikan seluruh kebutuhan **Aplikasi Android Mufatish** sebagai pengawas akademik