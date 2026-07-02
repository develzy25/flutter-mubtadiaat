# 101. Coding Standards & Data Integrity Specification

## General Coding Principles

- Standard ESLint, Prettier, TypeScript Strict Mode, dan Naming Conventions.
- Clean Code, SOLID, DRY, KISS, dan Feature-Based Architecture.

## Data Source & Dummy Data Policy

### Mandatory Rules

Seluruh source code WAJIB menggunakan data asli yang berasal dari:

- Database (Cloudflare D1)
- API Backend (Hono.js)
- Cloudinary Storage
- Better Auth

DILARANG keras menuliskan data dummy secara langsung (hardcode) di dalam source code production.

Contoh yang DILARANG:

```ts
const students = [
  {
    id: 1,
    name: "Ahmad",
    class: "A1"
  }
];
```

```tsx
<Card title="Jumlah Santri">
    250
</Card>
```

```ts
const dashboard = {
    attendance: 95,
    absent: 5
}
```

Semua data wajib berasal dari API atau Database.

## Dummy Data Policy

Apabila selama proses development diperlukan data dummy, maka data tersebut WAJIB ditempatkan di dalam Database Seed.

Contoh lokasi Seeder:

- `backend/drizzle/seed.ts`
- `database/seed/development.sql`

Tidak diperbolehkan membuat data dummy pada:

- React Component
- Hooks
- Services
- Stores
- Context
- API Handlers
- Repository
- Controller
- UI Component
- Constants

## Environment Separation

Gunakan pemisahan environment:

- **Development**: `development.sql` / `seed.ts`
- **Testing**: `testing.sql`
- **Production**: Tidak menggunakan dummy data sama sekali.

## Seeder Execution

Semua data contoh dibuat menggunakan Seeder (Role, Permission, Feature Flag, Tahun Ajaran, Semester, Kalender Akademik, Mapel, Kitab, Tingkatan, Kelas, Santri Dummy, Guru Dummy).

Seeder harus dapat dijalankan menggunakan satu perintah:

```bash
npm run db:seed
```

## Frontend Architecture & Mock API Layer

Frontend tidak boleh memiliki data statis. Semua halaman harus mengambil data melalui:

`TanStack Query -> API -> Cloudflare Worker -> Cloudflare D1`

Jika API backend belum tersedia, frontend tetap harus menggunakan **Mock API Layer** (misal `src/mocks/dashboard.mock.ts` atau Mock Service Worker / MSW), bukan data hardcode di dalam komponen React.

Setelah backend selesai, cukup mengganti endpoint tanpa mengubah komponen UI sama sekali.

## Switching Development to Production

Perpindahan dari Development ke Production TIDAK boleh memerlukan perubahan source code komponen UI.

Yang berubah hanya:

- Environment Variables (`.env`)
- API Base URL
- Database Connection Bindings
- Seeder Flag

Seluruh komponen React tetap sama.

## Production Release Rules

Sebelum release production wajib dipastikan:

- Tidak ada data dummy.
- Tidak ada hardcode business data.
- Tidak ada mock object.
- Tidak ada fake API.
- Tidak ada fake response.
- Tidak ada `console.log`.
- Tidak ada `TODO`.
- Tidak ada `FIXME`.
- Tidak ada placeholder yang belum diganti.

## UI/UX Spacing & Spans Layout Rules

> [!IMPORTANT]
> **Layout & Spacing Standards to Prevent Empty Gaps on Bottom Navigation Screens:**

- DILARANG keras memberikan padding bottom besar (seperti `pb-24` atau `pb-28`) di dalam halaman React individual yang berada di dalam `DashboardLayout`.
- `DashboardLayout.tsx` secara sentral telah mengelola `pb-28` untuk mengimbangi floating menu bar.
- Halaman individual di dalam `Outlet` hanya diperbolehkan menggunakan padding bottom kecil (maksimal `pb-6`) untuk merapatkan isi konten dengan floating bottom navigation bar.

## Mustahiq Class Ownership Rules

> [!IMPORTANT]
> **Mustahiq (Wali Kelas) 1-to-1 Class Mapping Rules:**

- Setiap Mustahiq hanya boleh memegang tepat **1 bagian** dan **1 lokal**.
- UI halaman untuk Mustahiq harus dikunci secara otomatis (*strictly locked*) pada kelas/lokal binaannya saja.
- Dilarang membuat selector pemilih bagian kelas (tab/horizontal bar) untuk akun dengan level Mustahiq, kecuali role akun tersebut adalah Mufatish atau Mundzir.

## AI Development Rules

AI DILARANG:

1. Mengarang data bisnis.
2. Membuat angka statistik palsu secara hardcode di UI.
3. Mengisi dashboard dengan data fiktif di dalam React Component.
4. Membuat nama santri, guru, kelas, atau kitab secara hardcode di komponen.
5. Membuat contoh response API statis di dalam source code production.

Apabila backend belum tersedia, AI WAJIB:

1. Membuat endpoint yang benar sesuai spesifikasi API.
2. Membuat database schema & migration (Drizzle ORM).
3. Membuat seeder (`seed.ts` / `dummy.sql`).
4. Menghubungkan frontend ke API tersebut (atau via Mock Service Layer).

AI tidak boleh mengganti implementasi API menjadi data statis hanya agar aplikasi terlihat berjalan.

### Utama Rule Principle

**No Hardcoded Business Data. Everything must come from Database, API, Seeder, or Mock Service Layer that can be disabled for Production.**
