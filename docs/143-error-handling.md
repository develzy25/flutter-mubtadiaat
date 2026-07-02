# 143. Comprehensive Error Handling Strategy

1. **Frontend Layer**: React Error Boundary + Toast Notification + Component Fallback State.
2. **Backend Middleware Layer**: Hono.js Centralized Error Handler (`app.onError`) menangkap exception Zod, D1 SQLITE_ERROR, & JWT errors.
3. **Offline Storage Layer**: Queueing request gagal di Dexie.js dengan exponential backoff retry.
4. **Cloudinary Storage**: Verifikasi status respon HTTP 200 sebelum menghapus record database.
