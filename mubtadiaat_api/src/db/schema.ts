import { sqliteTable, text, integer } from 'drizzle-orm/sqlite-core';

// --- USERS (Manajemen Pengguna) ---
export const users = sqliteTable('users', {
  id: text('id').primaryKey(), // UUID
  username: text('username').notNull().unique(),
  passwordHash: text('password_hash').notNull(),
  role: text('role').notNull(), // 'admin', 'mustahiq', 'mufattish', 'mundzir'
  fullName: text('full_name').notNull(),
  createdAt: integer('created_at', { mode: 'timestamp' }).notNull(),
});

export const hakAkses = sqliteTable('hak_akses', {
  id: text('id').primaryKey(),
  roleName: text('role_name').notNull(),
  permissions: text('permissions').notNull(), // e.g. "ALL", "READ_ONLY"
});

// --- MASTER DATA ---
export const tahunAjaran = sqliteTable('tahun_ajaran', {
  id: text('id').primaryKey(),
  name: text('name').notNull(), // e.g., "2025/2026"
  isActive: integer('is_active', { mode: 'boolean' }).default(false),
});

export const semester = sqliteTable('semester', {
  id: text('id').primaryKey(),
  name: text('name').notNull(), // "Ganjil" or "Genap"
  tahunAjaranId: text('tahun_ajaran_id').references(() => tahunAjaran.id),
  isActive: integer('is_active', { mode: 'boolean' }).default(false),
});

export const jenjang = sqliteTable('jenjang', {
  id: text('id').primaryKey(),
  name: text('name').notNull(), // I'dadiyah, Ibtida'iyyah, Tsanawiyah, Aliyah
});

export const kelas = sqliteTable('kelas', {
  id: text('id').primaryKey(),
  name: text('name').notNull(), // e.g., "3A Ibtida'iyyah"
  jenjangId: text('jenjang_id').references(() => jenjang.id),
  mustahiqId: text('mustahiq_id').references(() => users.id), // Wali kelas / Pengajar utama
});

export const siswi = sqliteTable('siswi', {
  id: text('id').primaryKey(),
  nis: text('nis').notNull().unique(),
  name: text('name').notNull(),
  kamar: text('kamar'),
  tempatLahir: text('tempat_lahir'),
  tanggalLahir: text('tanggal_lahir'),
  alamat: text('alamat'),
  namaAyah: text('nama_ayah'),
  namaIbu: text('nama_ibu'),
  kelasId: text('kelas_id').references(() => kelas.id),
  bagian: text('bagian'),
  tahunMasuk: text('tahun_masuk'),
  status: text('status').default('Aktif'), // Aktif, Cuti, Boyong
  tahunKeluar: text('tahun_keluar'),
  customFields: text('custom_fields', { mode: 'json' }), // Storing dynamic fields as JSON
});

export const mapel = sqliteTable('mapel', {
  id: text('id').primaryKey(),
  name: text('name').notNull(),
  jenjangId: text('jenjang_id').references(() => jenjang.id),
});

export const kamar = sqliteTable('kamar', {
  id: text('id').primaryKey(),
  name: text('name').notNull(),
});

export const bagian = sqliteTable('bagian', {
  id: text('id').primaryKey(),
  name: text('name').notNull(),
});

export const ekstrakurikuler = sqliteTable('ekstrakurikuler', {
  id: text('id').primaryKey(),
  name: text('name').notNull(),
});

// --- AKADEMIK & PENILAIAN ---
export const jadwal = sqliteTable('jadwal', {
  id: text('id').primaryKey(),
  hari: text('hari').notNull(),
  waktu: text('waktu').notNull(),
  mapel: text('mapel').notNull(),
  kelas: text('kelas').notNull(),
});

export const tamrin = sqliteTable('tamrin', {
  id: text('id').primaryKey(),
  name: text('name').notNull(),
  tanggal: text('tanggal').notNull(),
});

export const pembagianGuru = sqliteTable('pembagian_guru', {
  id: text('id').primaryKey(),
  guru: text('guru').notNull(),
  tugas: text('tugas').notNull(),
});

export const pembagianKelas = sqliteTable('pembagian_kelas', {
  id: text('id').primaryKey(),
  kelas: text('kelas').notNull(),
  waliKelas: text('wali_kelas').notNull(),
});

export const mutasi = sqliteTable('mutasi', {
  id: text('id').primaryKey(),
  siswa: text('siswa').notNull(),
  jenis: text('jenis').notNull(), // Pindah, Lulus
  tanggal: text('tanggal').notNull(),
});

export const validasiNilai = sqliteTable('validasi_nilai', {
  id: text('id').primaryKey(),
  kelas: text('kelas').notNull(),
  status: text('status').notNull(),
});

export const kunciNilai = sqliteTable('kunci_nilai', {
  id: text('id').primaryKey(),
  semester: text('semester').notNull(),
  isLocked: integer('is_locked', { mode: 'boolean' }).default(false),
});

export const erapor = sqliteTable('erapor', {
  id: text('id').primaryKey(),
  siswa: text('siswa').notNull(),
  semester: text('semester').notNull(),
  link: text('link').notNull(),
});

export const esertifikat = sqliteTable('esertifikat', {
  id: text('id').primaryKey(),
  siswa: text('siswa').notNull(),
  kegiatan: text('kegiatan').notNull(),
  link: text('link').notNull(),
});
