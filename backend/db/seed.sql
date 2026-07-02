-- seed.sql
-- Official seed data for Mubtadi'at MPHM Lirboyo local database

-- Clean existing data first in exact dependency order to prevent FK violations
DELETE FROM role_permissions;
DELETE FROM notification_reads;
DELETE FROM sessions;
DELETE FROM accounts;
DELETE FROM verifications;
DELETE FROM attendance_details;
DELETE FROM attendance;
DELETE FROM grade_items;
DELETE FROM grades;
DELETE FROM memorization_items;
DELETE FROM memorization;
DELETE FROM reports;
DELETE FROM santri_refs;
DELETE FROM kelas_refs;
DELETE FROM users;
DELETE FROM roles;
DELETE FROM permissions;
DELETE FROM notifications;
DELETE FROM feature_flags;
DELETE FROM settings;
DELETE FROM kitab_refs;

-- 1. Insert Roles (Without Munawwib per blueprint)
INSERT INTO roles (id, name, description, created_at, updated_at) VALUES 
('role-mustahiq', 'Mustahiq', 'Wali Kelas - Menginput nilai dan kehadiran kelas binaan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('role-mufatish', 'Mufatish', 'Pimpinan Tingkatan - Monitoring progres pengisian', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('role-mundzir', 'Mundzir', 'Pimpinan Madrasah - Approval akhir & monitoring global', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 2. Insert Basic Feature Flags
INSERT INTO feature_flags (id, key, name, is_enabled, created_at, updated_at) VALUES 
('feat-001', 'FEATURE_HAFALAN', 'Modul Hafalan', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('feat-002', 'FEATURE_RAPORT', 'Modul e-Raport', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('feat-003', 'FEATURE_QR_SCAN', 'QR Scan Absensi', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 3. Insert Users (Consistent with PWA mockup accounts)
INSERT INTO users (id, name, email, email_verified, image, created_at, updated_at) VALUES
('user-charis-wahyudi', 'Charis Wahyudi', 'charis.wahyudi@lirboyo.net', 1, null, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('user-abdurrahman-addakhel', 'Abdurrahman Addakhel', 'abdurrahman.addakhel@lirboyo.net', 1, null, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 4. Insert Kelas Refs (1 Mustahiq = 1 Class/Lokal strictly)
INSERT INTO kelas_refs (id, name, level, mustahiq_id, created_at, updated_at) VALUES
('kelas-001', 'Bagian A', 'Tsanawiyah', 'user-charis-wahyudi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('kelas-002', 'Bagian B', 'Tsanawiyah', 'user-abdurrahman-addakhel', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 5. Insert Santri Refs (Lirboyo Santri Putri)
INSERT INTO santri_refs (id, nis, name, class_id, status, created_at, updated_at) VALUES
('santri-001', '20260001', 'Aisyah Humaira', 'kelas-001', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('santri-002', '20260002', 'Fatimah Az-Zahra', 'kelas-001', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('santri-003', '20260003', 'Maryam', 'kelas-001', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('santri-004', '20260004', 'Naila Syafira', 'kelas-001', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('santri-005', '20260005', 'Zahra Salsabila', 'kelas-001', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('santri-006', '20260006', 'Khadijah', 'kelas-002', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('santri-007', '20260007', 'Safiyya', 'kelas-002', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 6. Insert Kitab Refs (Class specific curriculum)
INSERT INTO kitab_refs (id, name, description, created_at, updated_at) VALUES
('kitab-001', 'Tuhfatul Athfal', 'Tajwid', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('kitab-002', 'Khoridatul Bahiyyah', 'Tauhid', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('kitab-003', 'Mukhtashor Jiddan', 'Nahwu', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('kitab-004', 'Sullamut Taufiq', 'Fiqh', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 7. Seed Initial Monthly Attendance for Bagian A
INSERT INTO attendance (id, class_id, month, recorded_by, created_at, updated_at) VALUES
('att-001', 'kelas-001', '2026-07', 'user-charis-wahyudi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO attendance_details (id, attendance_id, santri_id, hadir, sakit, izin, alpha, notes, created_at, updated_at) VALUES
('att-det-001', 'att-001', 'santri-001', 26, 1, 1, 0, 'Aktif mengikuti kelas.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('att-det-002', 'att-001', 'santri-002', 28, 0, 0, 0, 'Sangat rajin.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('att-det-003', 'att-001', 'santri-003', 25, 2, 1, 0, 'Hadir teratur.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('att-det-004', 'att-001', 'santri-004', 27, 0, 1, 0, 'Aktif.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('att-det-005', 'att-001', 'santri-005', 28, 0, 0, 0, 'Sempurna.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
