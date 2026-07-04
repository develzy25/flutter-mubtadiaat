# e-Mubtadi'at | Aplikasi Manajemen Pendidikan Terpadu

**Single Source of Truth (SSOT)** - Proyek Sistem Informasi Akademik Mubtadi'at (Lingkungan Pendidikan MPHM).

## Project Overview
e-Mubtadi'at adalah solusi digital terstruktur, aman, dan terpusat untuk mendigitalisasi administrasi akademik mulai dari awal tahun ajaran hingga proses kelulusan. Sistem ini ditujukan bagi Administrator, Mundzir, Mufattish, dan Mustahiq dengan pengawasan ketat terhadap aturan bisnis (SOP MPHM).

## Technology Stack
* **Frontend:** Flutter (Android & Windows Desktop)
* **State Management:** Riverpod
* **Routing:** GoRouter
* **Networking:** Dio
* **Dependency Injection:** GetIt
* **Local Storage:** Hive & Flutter Secure Storage
* **Backend:** Cloudflare Workers (Hono Framework)
* **Database:** Cloudflare D1
* **Repository:** GitHub
* **Build System:** GitHub Actions (CI/CD)

## Project Structure
Sistem mengikuti arsitektur modular:
```text
lib/
├── core/       # Pondasi utama aplikasi (Network, Error, Storage, DI, Config)
├── features/   # Modul-modul fitur mandiri (Santri, Penilaian, Dashboard)
├── shared/     # Komponen UI dan ekstensi yang digunakan bersama
└── main.dart   # Entry point aplikasi
```

## Clean Architecture
Setiap modul di dalam `features/` menggunakan pendekatan **Clean Architecture**:
1. **`presentation/`**: UI, Widget, State Management.
2. **`application/`**: Use Case, Service, Validator, RBAC.
3. **`domain/`**: Business Rule utama, Entitas, Abstraksi.
4. **`infrastructure/`**: Repository Impl, API Client, Local Cache.

## Blueprint Location
Seluruh dokumentasi dan Blueprint resmi (SSOT) berada di folder:
`/docs/`

## Coding Standard
* **Database (Tabel/Kolom):** `snake_case` (e.g., `data_santri`)
* **Variabel/Fungsi (Dart):** `camelCase` (e.g., `inputNilaiKhusus()`)
* **Class/Repo/Service:** `PascalCase` (e.g., `PenilaianService`)
* **Endpoint API:** `kebab-case` (e.g., `/api/v1/rekap-nilai`)
* **Response Model:** Seluruh API wajib merespon dengan format JSON standar yang diparsing menggunakan kelas generic `ApiResponse<T>`.

## Branch Strategy
* `main`: Kode produksi stabil.
* `develop`: Branch integrasi utama.
* `feature/*`: Branch pengembangan fitur (contoh: `feature/penilaian`).

## Build Workflow & CI/CD
Semua *build* (Android APK, AAB, Windows EXE) dijalankan otomatis via GitHub Actions. Proses manual lokal hanya untuk pengujian tahap *development*.

## Development Rules
1. **Frontend dilarang keras mengakses database langsung.** Semua operasi data melalui REST API.
2. **Satu Data, Satu Alur, Satu Standar.**
3. **Audit Trail.** Setiap aktivitas mutasi data krusial akan terekam ke dalam audit log server.
4. Penggunaan zona waktu standar UTC (+00:00) yang disesuaikan saat tampil di sisi *client*.

## License
Hak Cipta © 2026 MPHM. Hak cipta dilindungi undang-undang.
