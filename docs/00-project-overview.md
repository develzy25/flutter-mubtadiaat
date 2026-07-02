# 00. Project Overview - Mubtadi'at

## Identitas Proyek

- **Nama Sistem**: Mubtadi'at
- **Sub Judul**: Pondok Pesantren Hidayatul Mubtadi'at Lirboyo Kediri (Pondok Putri)
- **Status Dokumen**: Single Source of Truth (SSOT) - Production Ready

## Deskripsi Enterprise

e-Mubtadi'aat adalah platform sistem informasi manajemen pendidikan akademik terpadu yang dirancang khusus untuk Pondok Pesantren Hidayatul Mubtadi'at Lirboyo Kediri. Sistem ini memisahkan secara tegas dua domain aplikasi utama:

1. **PWA Mobile Pengajar**: Aplikasi operasional harian tanpa fungsi administratif untuk Mustahiq (Wali Kelas / Pengajar), Mufatish (Pimpinan Tingkatan), dan Mundzir (Pimpinan Madrasah).
2. **Software Administrasi (Web Desktop)**: Portal terpusat pengelola madrasah untuk manajemen Master Data, Akademik, Penerbitan E-Raport/E-Ijazah, RBAC, & Audit Trail.

## Stack Arsitektur Utama

- **Frontend**: React 19, Vite, TypeScript, React Router, TanStack Query, Zustand, React Hook Form, Zod, Tailwind CSS v4, Framer Motion, Lucide React, Dexie.js, Workbox PWA.
- **Backend & Middleware**: Cloudflare Workers, Hono.js, Drizzle ORM, Better Auth, JWT, HttpOnly Cookies, Cloudinary API.
- **Database & Hosting**: Cloudflare D1 (SQLite), Cloudflare Pages (Frontend), Cloudflare Workers (Backend API).

## Mandatory Data Integrity & AI Rules

> [!IMPORTANT]
> **No Hardcoded Business Data. Everything must come from Database, API, Seeder, or Mock Service Layer that can be disabled for Production.**

- DILARANG keras menuliskan data bisnis secara dummy/hardcode langsung di komponen React UI.
- Semua data dummy pengembangan wajib dikelola via seeder (`seed.ts` / `development.sql`) atau Mock API Layer terpisah.
- AI Assistant wajib mematuhi aturan ini secara mutlak pada seluruh siklus pengembangan proyek.
