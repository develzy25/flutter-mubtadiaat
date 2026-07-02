# 141. Database Naming & Schema Conventions

1. **Table Names**: Lowercase `snake_case` plural (misal: `users`, `santri`, `attendance_details`).
2. **Primary Key**: String UUID v4 (`id`).
3. **Foreign Keys**: `singular_table_name_id` (misal: `class_id`, `user_id`).
4. **Timestamps**: Unix Epoch Timestamp / ISO 8601 string (`created_at`, `updated_at`).
5. **Soft Delete**: `deleted_at` nullable timestamp.
6. **Audit Columns**: `created_by_user_id`, `updated_by_user_id`.
