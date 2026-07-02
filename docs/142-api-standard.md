# 142. Standard API Response Structure

Seluruh endpoint backend Hono.js **WAJIB** mengembalikan format JSON standar berikut:

```json
{
  "success": true,
  "message": "Presensi santri berhasil disimpan",
  "data": {
    "attendanceId": "c8a45b78-12e3-4d56-8f90-123456789abc",
    "recordedCount": 32
  },
  "meta": {
    "page": 1,
    "pageSize": 50,
    "total": 32
  },
  "errors": []
}
```

Jika terjadi error validation atau sistem:
```json
{
  "success": false,
  "message": "Validasi gagal pada payload request",
  "data": null,
  "meta": null,
  "errors": [
    {
      "field": "email",
      "code": "INVALID_EMAIL",
      "message": "Format alamat email tidak valid"
    }
  ]
}
```
