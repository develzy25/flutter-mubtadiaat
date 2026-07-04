CREATE TABLE `jenjang` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `kelas` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`jenjang_id` text,
	`mustahiq_id` text,
	FOREIGN KEY (`jenjang_id`) REFERENCES `jenjang`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`mustahiq_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `mapel` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`jenjang_id` text,
	FOREIGN KEY (`jenjang_id`) REFERENCES `jenjang`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `semester` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`tahun_ajaran_id` text,
	`is_active` integer DEFAULT false,
	FOREIGN KEY (`tahun_ajaran_id`) REFERENCES `tahun_ajaran`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `siswi` (
	`id` text PRIMARY KEY NOT NULL,
	`nis` text NOT NULL,
	`name` text NOT NULL,
	`kelas_id` text,
	FOREIGN KEY (`kelas_id`) REFERENCES `kelas`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `siswi_nis_unique` ON `siswi` (`nis`);--> statement-breakpoint
CREATE TABLE `tahun_ajaran` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`is_active` integer DEFAULT false
);
--> statement-breakpoint
CREATE TABLE `users` (
	`id` text PRIMARY KEY NOT NULL,
	`username` text NOT NULL,
	`password_hash` text NOT NULL,
	`role` text NOT NULL,
	`full_name` text NOT NULL,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_username_unique` ON `users` (`username`);