# 30. Database Schema - Cloudflare D1 (Drizzle ORM)

## Entity Relationship Summary
Database dikelola menggunakan Drizzle ORM pada Cloudflare D1 (SQLite engine).

### Tabel-Tabel Utama:
1. `users` & `sessions` & `accounts`: Autentikasi Better-Auth.
2. `santri`: Data identitas santri putri (NISN, Nama, KelasId, Status).
3. `classes` & `subjects`: Data kelas dan kitab/mata pelajaran.
4. `attendance`: Catatan presensi harian santri (`Hadir`, `Sakit`, `Izin`, `Alpha`).
5. `grades`: Catatan nilai semester dan e-raport.
6. `audit_logs`: Catatan riwayat aktivitas sistem.
