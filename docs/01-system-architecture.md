# 01. System Architecture - Mubtadi'at

## Arsitektur Teknologi

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                         │
│  ┌────────────────────────┐  ┌───────────────────────┐  │
│  │   PWA Mobile (React)   │  │ Web Admin (React/Vite)│  │
│  └───────────┬────────────┘  └───────────┬───────────┘  │
└──────────────┼───────────────────────────┼──────────────┘
               │ HTTPS / JSON REST API     │
┌──────────────▼───────────────────────────▼──────────────┐
│                    BACKEND LAYER                        │
│  ┌───────────────────────────────────────────────────┐  │
│  │     Cloudflare Workers / Hono.js Engine           │  │
│  │  ┌─────────────────┐ ┌─────────────────────────┐  │  │
│  │  │  Better-Auth    │ │ Service Worker Sync API │  │  │
│  │  └─────────────────┘ └─────────────────────────┘  │  │
│  └─────────────────────────┬─────────────────────────┘  │
└────────────────────────────┼────────────────────────────┘
                             │ Drizzle ORM
┌────────────────────────────▼────────────────────────────┐
│                    DATABASE & STORAGE                   │
│  ┌────────────────────────┐  ┌───────────────────────┐  │
│  │  Cloudflare D1 (SQLite)│  │ Cloudinary Media API  │  │
│  └────────────────────────┘  └───────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## Komponen Komponen Utama
1. **Frontend (Client)**:
   - React 19 + TypeScript + Vite.
   - TailwindCSS v4 + Custom 3D Neumorphic Utility Tokens.
   - Framer Motion untuk animasi micro-interaction.
   - TanStack Query untuk caching data server.

2. **Backend (Serverless Engine)**:
   - Hono.js framework ringan pada Cloudflare Workers environment.
   - Better-Auth untuk sistem autentikasi session-based & token.
   - Drizzle ORM untuk type-safe SQL query ke Cloudflare D1.

3. **Database & External Services**:
   - Cloudflare D1 (Relational Distributed SQLite Database).
   - Cloudinary SDK untuk optimalisasi foto santri & e-ijazah.
