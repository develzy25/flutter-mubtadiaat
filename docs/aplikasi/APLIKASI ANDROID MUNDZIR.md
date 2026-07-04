# BLUEPRINT 03 — APLIKASI ANDROID MUNDZIR

## Tujuan

Aplikasi Mundzir merupakan aplikasi Android yang digunakan oleh **Mundzir** sebagai pimpinan bidang pendidikan untuk melakukan pengawasan menyeluruh, analisis, pengambilan keputusan, persetujuan akhir, serta monitoring seluruh aktivitas akademik di Pondok.

Mundzir tidak melakukan input data harian seperti Mustahiq, melainkan berfokus pada **kontrol, evaluasi, analisis, dan kebijakan**.

---

# Hak Akses

Role:

* Mundzir

Mundzir memiliki akses terhadap seluruh data akademik pondok sesuai kewenangan yang diberikan oleh Admin.

---

# Dashboard

Halaman utama menampilkan kondisi pondok secara keseluruhan.

Menampilkan:

* Ucapan Selamat Datang
* Nama Mundzir
* Tahun Ajaran Aktif
* Semester Aktif
* Jumlah Santri Aktif
* Jumlah Kelas
* Jumlah Mustahiq
* Jumlah Mufatish
* Persentase Kehadiran Santri
* Persentase Kehadiran Guru
* Status Pengisian Nilai
* Status Validasi Nilai
* Status Tamrin
* Jumlah Pelanggaran
* Jumlah Prestasi
* Jadwal Hari Ini
* Pengumuman
* Notifikasi Penting

---

# Menu Utama

## 1. Dashboard

Ringkasan seluruh aktivitas akademik.

---

## 2. Monitoring Akademik

Menampilkan kondisi seluruh pembelajaran.

Informasi:

* Jumlah kelas aktif
* Jumlah mata pelajaran
* Jumlah nilai selesai
* Jumlah nilai belum selesai
* Persentase penyelesaian
* Grafik perkembangan

---

## 3. Monitoring Kelas

Menampilkan seluruh kelas.

Informasi:

* Nama kelas
* Mustahiq
* Jumlah santri
* Kehadiran
* Nilai
* Status administrasi
* Status validasi

---

## 4. Monitoring Guru

Melihat data seluruh:

* Mustahiq
* Mufatish

Informasi:

* Kehadiran
* Kinerja
* Jumlah tugas
* Penyelesaian administrasi
* Status aktivitas

---

## 5. Monitoring Santri

Melihat seluruh data santri.

Meliputi:

* Biodata
* Nilai
* Absensi
* Akhlak
* Al-Qur'an
* Prestasi
* Pelanggaran
* Tamrin
* Riwayat akademik

---

## 6. Monitoring Penilaian

Menampilkan:

* Rekap seluruh nilai
* Ranking
* Distribusi nilai
* Nilai rata-rata
* Nilai tertinggi
* Nilai terendah
* Grafik perkembangan

---

## 7. Monitoring Absensi

Menampilkan:

* Kehadiran harian
* Bulanan
* Semester
* Persentase tiap kelas
* Persentase tiap guru

---

## 8. Monitoring Akhlak

Melihat perkembangan akhlak seluruh santri.

Disajikan dalam bentuk:

* Grafik
* Rekap
* Statistik
* Detail per santri
* Detail per kelas

---

## 9. Monitoring Al-Qur'an

Menampilkan perkembangan:

* Tahsin
* Tahfidz
* Target Hafalan
* Kelulusan
* Statistik capaian

---

## 10. Monitoring Tamrin

Menampilkan:

* Jadwal
* Peserta
* Nilai
* Penguji
* Hasil
* Kelulusan
* Statistik Tamrin

---

## 11. Monitoring Pelanggaran

Menampilkan:

* Jumlah pelanggaran
* Jenis pelanggaran
* Tingkat pelanggaran
* Santri terbanyak melakukan pelanggaran
* Statistik bulanan
* Grafik tren

---

## 12. Monitoring Prestasi

Menampilkan:

* Prestasi akademik
* Prestasi non akademik
* Prestasi per kelas
* Prestasi per semester

---

## 13. Persetujuan Akhir (Final Approval)

Melakukan persetujuan akhir terhadap:

* Rekap Nilai
* Hasil Semester
* Hasil Tamrin
* Kelulusan administrasi akademik
* Dokumen akademik yang memerlukan otorisasi

Fitur:

* Setujui
* Tolak
* Kembalikan untuk revisi
* Berikan catatan

---

## 14. Laporan

Menampilkan berbagai laporan:

* Rekap Nilai
* Rekap Absensi
* Rekap Akhlak
* Rekap Al-Qur'an
* Rekap Tamrin
* Rekap Prestasi
* Rekap Pelanggaran
* Rekap Kinerja Guru
* Statistik Akademik

---

## 15. Kalender Akademik

Menampilkan:

* Awal Semester
* Ujian
* Tamrin
* Libur Pondok
* Wisuda
* Pembagian Rapor
* Agenda Pendidikan

---

## 16. Pengumuman

Melihat seluruh pengumuman resmi.

---

## 17. Notifikasi

Berisi:

* Nilai belum selesai
* Validasi menunggu persetujuan
* Jadwal Tamrin
* Pengumuman baru
* Deadline administrasi
* Peringatan sistem

---

## 18. Analitik & Statistik

Dashboard analitik interaktif yang menampilkan:

* Grafik perkembangan nilai
* Grafik kehadiran
* Grafik akhlak
* Grafik Al-Qur'an
* Grafik pelanggaran
* Grafik prestasi
* Perbandingan antar kelas
* Perbandingan antar semester
* Perbandingan antar tahun ajaran

---

## 19. Profil

Berisi:

* Data diri
* Foto
* Nomor HP
* Email
* Jabatan
* Ubah password

---

## 20. Bantuan

Berisi:

* Panduan penggunaan
* FAQ
* Hubungi Admin

---

# Hak Akses

Mundzir **dapat**:

* Melihat seluruh data akademik pondok.
* Melakukan persetujuan akhir sesuai kewenangan.
* Melihat statistik dan analitik lengkap.
* Memberikan catatan dan evaluasi.
* Memantau kinerja Mustahiq dan Mufatish.
* Mengakses seluruh laporan akademik.

Mundzir **tidak dapat**:

* Mengelola data master (santri, guru, kelas, mata pelajaran, dll.).
* Menambah atau menghapus pengguna.
* Mengubah konfigurasi sistem.
* Mengubah rumus penilaian.
* Mengelola database atau pengaturan backend.

---

# Validasi Sistem

* Semua persetujuan akhir tercatat dalam **audit trail**.
* Setiap penolakan wajib disertai alasan.
* Riwayat revisi dan persetujuan tersimpan permanen.
* Dashboard diperbarui secara real-time setelah sinkronisasi dengan backend Cloudflare.
* Seluruh aktivitas pengguna direkam untuk keperluan audit dan pelacakan.

Dengan blueprint ini, aplikasi **Mundzir** berfungsi sebagai pusat **monitoring, evaluasi, analisis, dan persetujuan akademik** di tingkat pimpinan, sementara seluruh administrasi sistem tetap dikelola melalui **Software Admin Desktop**.
