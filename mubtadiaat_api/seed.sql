-- Seed Data untuk Manajemen Pengguna
INSERT INTO users (id, username, password_hash, role, full_name, created_at) VALUES 
('admin-1', 'admin', 'hash_dummy', 'admin', 'Administrator Utama', strftime('%s', 'now')),
('mustahiq-1', 'ahmad', 'hash_dummy', 'mustahiq', 'Ust. Ahmad Fauzi', strftime('%s', 'now')),
('mufattish-1', 'mufattish', 'hash_dummy', 'mufattish', 'K.H. Abdul Mufattish', strftime('%s', 'now')),
('mundzir-1', 'mundzir', 'hash_dummy', 'mundzir', 'K.H. Mundzir Akbar', strftime('%s', 'now'));

-- Seed Master Data
INSERT INTO jenjang (id, name) VALUES 
('j-1', 'I''dadiyah'),
('j-2', 'Ibtida''iyyah'),
('j-3', 'Tsanawiyah'),
('j-4', 'Aliyah');

INSERT INTO kelas (id, name, jenjang_id, mustahiq_id) VALUES 
('k-3a-ibt', '3A Ibtida''iyyah', 'j-2', 'mustahiq-1'),
('k-2b-tsn', '2B Tsanawiyah', 'j-3', 'mustahiq-1'),
('k-1-aly', '1 Aliyah', 'j-4', NULL);

INSERT INTO mapel (id, name, jenjang_id) VALUES 
('m-1', 'Fiqih (Fathul Qorib)', 'j-2'),
('m-2', 'Nahwu (Jurumiyyah)', 'j-3');
