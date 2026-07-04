CREATE TABLE `erapor` (
	`id` text PRIMARY KEY NOT NULL,
	`siswa` text NOT NULL,
	`semester` text NOT NULL,
	`link` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `esertifikat` (
	`id` text PRIMARY KEY NOT NULL,
	`siswa` text NOT NULL,
	`kegiatan` text NOT NULL,
	`link` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `jadwal` (
	`id` text PRIMARY KEY NOT NULL,
	`hari` text NOT NULL,
	`waktu` text NOT NULL,
	`mapel` text NOT NULL,
	`kelas` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `kunci_nilai` (
	`id` text PRIMARY KEY NOT NULL,
	`semester` text NOT NULL,
	`is_locked` integer DEFAULT false
);
--> statement-breakpoint
CREATE TABLE `mutasi` (
	`id` text PRIMARY KEY NOT NULL,
	`siswa` text NOT NULL,
	`jenis` text NOT NULL,
	`tanggal` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `pembagian_guru` (
	`id` text PRIMARY KEY NOT NULL,
	`guru` text NOT NULL,
	`tugas` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `pembagian_kelas` (
	`id` text PRIMARY KEY NOT NULL,
	`kelas` text NOT NULL,
	`wali_kelas` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `tamrin` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`tanggal` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `validasi_nilai` (
	`id` text PRIMARY KEY NOT NULL,
	`kelas` text NOT NULL,
	`status` text NOT NULL
);
