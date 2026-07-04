BLUEPRINT FINAL
APLIKASI ANDROID MUSTAHIQ
Versi 1.0 (Official Blueprint)
BAB 1. TUJUAN APLIKASI

Aplikasi Android Mustahiq merupakan aplikasi operasional yang digunakan oleh Guru Kelas (Mustahiq) untuk melaksanakan administrasi akademik kelas secara digital.

Seluruh aktivitas Mustahiq dilakukan melalui aplikasi ini, mulai dari pengelolaan data santri, absensi, penilaian, akhlak, hingga proses finalisasi nilai sebelum diproses lebih lanjut oleh Admin.

Aplikasi terhubung langsung dengan Backend Cloudflare melalui API sehingga seluruh data tersimpan secara terpusat.

BAB 2. HAK AKSES

Role :

Mustahiq

Hak akses:

✅ Login

✅ Dashboard

✅ Melihat data kelas sendiri

✅ Melihat data santri kelas sendiri

✅ Input absensi

✅ Input akhlaq

✅ Memeriksa nilai

✅ Finalisasi kelas

✅ Melihat raport

✅ Melihat Al-Bayan

✅ Melihat pengumuman

✅ Melihat kalender akademik

❌ Tidak dapat mengubah data master

❌ Tidak dapat menghapus santri

❌ Tidak dapat mengubah rumus penilaian

❌ Tidak dapat membuka finalisasi

❌ Tidak dapat mengelola pengguna

BAB 3. LOGIN

Field

Username
Password

Tombol

Masuk

Fitur

Remember Login
JWT Authentication
Auto Refresh Token
Logout
BAB 4. DASHBOARD

Dashboard hanya menampilkan informasi yang dibutuhkan Mustahiq.

Ringkasan
Nama Mustahiq
Tahun Ajaran
Semester Aktif
Nama Kelas
Jumlah Siswi Aktif
Jumlah Siswi Mutasi
Absensi Hari Ini
Status Pengisian Nilai
Status Finalisasi
Pengumuman
Kalender Hari Ini
Shortcut
Data Siswi
Absensi
Penilaian
Akhlaq
Raport
Finalisasi
Notifikasi

Misalnya:

Nilai Kuartal 1 belum lengkap.
Nilai Semester I belum lengkap.
Ada siswi belum memiliki nilai.
Finalisasi belum dapat dilakukan.
BAB 5. MENU DATA SISWI

Menu ini menampilkan seluruh siswi dalam kelas Mustahiq.

Tidak dapat menambah atau menghapus.

Hanya melihat data.

Daftar Siswi

Menampilkan:

Foto
NIS
Nama
Status

Status:

Aktif
Mutasi
Alumni
Detail Siswi

Berisi:

Identitas
NIS
Nama Lengkap
Tempat Lahir
Tanggal Lahir
Nama Orang Tua
Alamat
Nomor HP Wali
Akademik
Kelas
Tahun Ajaran
Semester
Riwayat
Absensi
Nilai
Akhlaq
Prestasi
Al-Bayan
Raport
BAB 6. MENU ABSENSI

Ini adalah menu yang digunakan setiap hari.

Input Absensi

Tanggal

↓

Daftar Siswi

↓

Status

Pilihan:

✅ Hadir

✅ Sakit

✅ Bi Idzni (Izin)

✅ Bi Ghoirihi (Tanpa Izin)

Karena kedua status ini digunakan dalam perhitungan Akhlaq dan Prestasi sesuai SOP penilaian.

Validasi

Tidak boleh ada:

dua status
status kosong
tanggal ganda
Rekap Absensi

Menampilkan:

Jumlah

Hadir
Sakit
Bi Idzni
Bi Ghoirihi

Per:

Bulan
Semester
BAB 7. MENU PENILAIAN

Ini merupakan menu terbesar dalam aplikasi.

Semua mengikuti Blueprint Penilaian MPHM.

Struktur:

Penilaian

├── Kuartal 1
├── Kuartal 2
├── Semester I
│
├── Kuartal 3
├── Kuartal 4
├── Semester II
│
├── Raport
│
├── Prestasi
│
└── Finalisasi
Kuartal 1

Jenis

Tamrin Semester I

Input

Untuk setiap mata pelajaran

Input:

Nilai asli

Contoh

6

6½

7

7½

8

8½

9

9½

10

Belum dilakukan pembulatan pada tahap ini.

Validasi Nilai
Mata Pelajaran

Al-Qur'an

Akhlaq

Nilai maksimal

8

Mata Pelajaran lainnya

Nilai maksimal

10

Nilai boleh

½

0,5

sesuai pedoman.

Kuartal 2

Input Ujian Semester I

Format sama seperti Kuartal 1.

Semester I

Setelah seluruh nilai masuk

Sistem otomatis menghitung:

Nilai Khos

Rumus:

(Nilai Kuartal 1 + Nilai Kuartal 2) ÷ 2

Kemudian dilakukan pembulatan sesuai aturan MPHM.

Kuartal 3

Tamrin Semester II

Kuartal 4

Ujian Semester II

Semester II

Sistem menghitung otomatis:

Nilai Khos Semester II

Nilai 'Am

Tidak dapat dihitung sebelum kelas difinalisasi.

Menggunakan seluruh Nilai Khos setiap mata pelajaran dan jumlah siswi aktif sesuai ketentuan resmi.

BAB 8. MENU AKHLAQ

Input nilai Akhlaq.

Nilai maksimal:

Komponen pendukung:

Perilaku sehari-hari
Rekap absensi
Catatan Mustahiq

Sistem juga memberikan peringatan apabila jumlah Bi Idzni atau Bi Ghoirihi telah mencapai batas yang memengaruhi penurunan nilai Akhlaq sesuai ketentuan.

BAB 9. MENU FINALISASI NILAI KELAS

Ini adalah menu terpenting bagi Mustahiq.

Sebelum tombol Finalisasi Nilai Kelas aktif, sistem harus memeriksa:

Semua nilai Kuartal telah terisi.
Semua Nilai Khos berhasil dihitung.
Nilai Akhlaq telah diisi.
Tidak ada data yang kosong.

Jika seluruh syarat terpenuhi:

Tombol Finalisasi Nilai Kelas aktif.

Setelah dikirim:

Status berubah menjadi Menunggu Persetujuan Admin.
Mustahiq tidak dapat lagi mengubah nilai sampai Admin membuka kembali jika diperlukan. Proses ini mengikuti alur finalisasi yang telah ditetapkan pada blueprint penilaian.
BAB 10. MENU RAPORT

Mustahiq hanya dapat:

Melihat hasil Raport Semester I.
Melihat hasil Raport Semester II.
Memeriksa data sebelum dicetak oleh Admin.

Tidak dapat mencetak maupun mengubah isi raport.

BAB 11. MENU AL-BAYAN

Menampilkan hasil akhir Prestasi (Al-Bayan) yang dihitung otomatis berdasarkan Nilai Khos, pembulatan, serta pengurangan karena Bi Idzni dan Bi Ghoirihi sesuai rumus resmi MPHM.

BAB 12. MENU PENGUMUMAN

Menampilkan pengumuman resmi dari Admin.

Tidak dapat membuat atau mengubah pengumuman.

BAB 13. MENU KALENDER AKADEMIK

Menampilkan:

Awal Tahun Ajaran
Jadwal Tamrin
Jadwal Ujian
Pembagian Raport
Libur Madrasah
Agenda Akademik
BAB 14. MENU PROFIL

Berisi:

Foto
Nama
Jabatan
Kelas yang diampu
Nomor HP
Ubah Password
Logout