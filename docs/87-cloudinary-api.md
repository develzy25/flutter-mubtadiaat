# 87. Cloudinary Media Integration & Delete Flow Specification

## Format Metadata Media di Database
Saat file diunggah ke Cloudinary, metadata berikut **WAJIB** disimpan di tabel `media`:
- `id` (UUID Primary Key)
- `public_id`
- `provider` ("cloudinary")
- `provider_id`
- `secure_url`
- `resource_type` ("image" / "raw" / "video")
- `mime_type`
- `extension`
- `etag`
- `version`
- `folder`
- `width`, `height`, `bytes`
- `uploaded_at`

## Delete Flow (Anti-Orphan File Policy)

```mermaid
sequenceDiagram
    autonumber
    actor User as User / Admin
    participant API as Hono.js Backend API
    participant CLD as Cloudinary Service API
    participant DB as Cloudflare D1 Database

    User->>API: DELETE /api/media/:publicId
    API->>API: Authenticate & Validate Permission (RBAC)
    API->>CLD: Delete File (public_id)
    alt Cloudinary Deletion Successful
        CLD-->>API: 200 OK (Result: 'ok')
        API->>DB: DELETE FROM media WHERE public_id = :publicId
        DB-->>API: Record Deleted
        API-->>User: 200 OK Response { success: true }
    else Cloudinary Deletion Failed
        CLD-->>API: Error / Exception
        API-->>User: 500 Internal Error (DB Record Preserved)
    end
```
