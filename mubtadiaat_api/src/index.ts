import { Hono } from 'hono';
import { drizzle } from 'drizzle-orm/d1';
import { cors } from 'hono/cors';
import * as schema from './db/schema.js';
import { eq } from 'drizzle-orm';
import ExcelJS from 'exceljs';
import * as xlsx from 'xlsx';

export interface Env {
  DB: D1Database;
}

const app = new Hono<{ Bindings: Env }>();

// Enable CORS for Flutter web/app testing
app.use('/api/*', cors());

app.get('/api/health', (c) => c.json({ status: 'ok', message: "Mubtadi'at API is running" }));

// --- USERS ---
app.get('/api/v1/users', async (c) => {
  const db = drizzle(c.env.DB);
  const role = c.req.query('role');
  if (role) {
    const result = await db.select().from(schema.users).where(eq(schema.users.role, role));
    return c.json(result);
  }
  const result = await db.select().from(schema.users);
  return c.json(result);
});

app.post('/api/v1/users', async (c) => {
  const db = drizzle(c.env.DB);
  const body = await c.req.json();
  // Simplified UUID gen for local testing since crypto.randomUUID might need node compat
  const newId = Date.now().toString(); 
  await db.insert(schema.users).values({
    id: newId,
    username: body.username,
    passwordHash: body.passwordHash || 'hash_placeholder',
    role: body.role,
    fullName: body.fullName,
    createdAt: new Date(),
  });
  return c.json({ success: true, id: newId });
});

app.put('/api/v1/users/:id', async (c) => {
  const db = drizzle(c.env.DB);
  const id = c.req.param('id');
  const body = await c.req.json();
  await db.update(schema.users).set({
    username: body.username,
    role: body.role,
    fullName: body.fullName,
  }).where(eq(schema.users.id, id));
  return c.json({ success: true });
});

app.delete('/api/v1/users/:id', async (c) => {
  const db = drizzle(c.env.DB);
  const id = c.req.param('id');
  await db.delete(schema.users).where(eq(schema.users.id, id));
  return c.json({ success: true });
});

// --- MASTER DATA: Jenjang ---
app.get('/api/v1/jenjang', async (c) => {
  const db = drizzle(c.env.DB);
  const result = await db.select().from(schema.jenjang);
  return c.json(result);
});

// --- MASTER DATA: Kelas ---
app.get('/api/v1/kelas', async (c) => {
  const db = drizzle(c.env.DB);
  const mustahiqId = c.req.query('mustahiqId');
  if (mustahiqId) {
    const result = await db.select().from(schema.kelas).where(eq(schema.kelas.mustahiqId, mustahiqId));
    return c.json(result);
  }
  const result = await db.select().from(schema.kelas);
  return c.json(result);
});

app.post('/api/v1/kelas', async (c) => {
  const db = drizzle(c.env.DB);
  const body = await c.req.json();
  const newId = Date.now().toString();
  await db.insert(schema.kelas).values({
    id: newId,
    name: body.name,
    jenjangId: body.jenjangId,
    mustahiqId: body.mustahiqId,
  });
  return c.json({ success: true, id: newId });
});

app.put('/api/v1/kelas/:id', async (c) => {
  const db = drizzle(c.env.DB);
  const id = c.req.param('id');
  const body = await c.req.json();
  await db.update(schema.kelas).set({
    name: body.name,
    jenjangId: body.jenjangId,
    mustahiqId: body.mustahiqId,
  }).where(eq(schema.kelas.id, id));
  return c.json({ success: true });
});

app.delete('/api/v1/kelas/:id', async (c) => {
  const db = drizzle(c.env.DB);
  const id = c.req.param('id');
  await db.delete(schema.kelas).where(eq(schema.kelas.id, id));
  return c.json({ success: true });
});

// --- MASTER DATA: Siswi ---
app.get('/api/v1/siswi/template', async (c) => {
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet('mubtadiat-template');
  
  await worksheet.protect('mubtadiat-template', {
    selectLockedCells: true,
    selectUnlockedCells: true,
    formatCells: false,
    insertRows: true,
    deleteRows: true,
  });

  const columns = [
    { header: 'NO_STAMBUK', key: 'nis', width: 20 },
    { header: 'NAMA', key: 'name', width: 30 },
    { header: 'KELAS_ID', key: 'kelasId', width: 20 },
    { header: 'KAMAR', key: 'kamar', width: 15 },
    { header: 'TEMPAT_LAHIR', key: 'tempatLahir', width: 20 },
    { header: 'TANGGAL_LAHIR', key: 'tanggalLahir', width: 20 },
    { header: 'ALAMAT', key: 'alamat', width: 30 },
    { header: 'NAMA_AYAH', key: 'namaAyah', width: 25 },
    { header: 'NAMA_IBU', key: 'namaIbu', width: 25 },
    { header: 'BAGIAN', key: 'bagian', width: 15 },
    { header: 'TAHUN_MASUK', key: 'tahunMasuk', width: 15 },
    { header: 'STATUS', key: 'status', width: 15 },
    { header: 'TAHUN_KELUAR', key: 'tahunKeluar', width: 15 }
  ];
  worksheet.columns = columns;

  const row = worksheet.getRow(1);
  row.eachCell((cell) => {
    cell.protection = { locked: true };
    cell.font = { bold: true, color: { argb: 'FFFFFFFF' } };
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF1E40AF' } };
    cell.note = {
      texts: [
        { font: { bold: true, size: 10 }, text: cell.value + '\n' },
        { font: { size: 9 }, text: 'Tipe: Teks | Wajib: Ya\n' },
        { font: { size: 9 }, text: 'Contoh: Isi Sesuai Data' }
      ]
    };
  });

  for (let rowNum = 2; rowNum <= 100; rowNum++) {
    worksheet.getRow(rowNum).eachCell({ includeEmpty: true }, (cell) => {
      cell.protection = { locked: false };
    });
  }

  const buffer = await workbook.xlsx.writeBuffer();
  c.header('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  c.header('Content-Disposition', 'attachment; filename="Template_Siswi_Mubtadiat.xlsx"');
  return c.body(buffer as any);
});

app.post('/api/v1/siswi/import', async (c) => {
  const db = drizzle(c.env.DB);
  const body = await c.req.parseBody();
  const file = body['file'] as File;
  if (!file) return c.json({ error: 'No file uploaded' }, 400);

  const buffer = await file.arrayBuffer();
  const wb = xlsx.read(buffer, { type: 'buffer' });
  const sheetName = wb.SheetNames[0];
  if (!sheetName) return c.json({ error: 'No sheets found in file' }, 400);
  const ws = wb.Sheets[sheetName];
  if (!ws) return c.json({ error: 'Sheet is empty or invalid' }, 400);
  const data = xlsx.utils.sheet_to_json(ws);
  
  if (!data || data.length === 0) return c.json({ error: 'Empty file' }, 400);

  const rowsToInsert = data.map((row: any, i) => ({
    id: Date.now().toString() + '_' + i,
    nis: row.NO_STAMBUK ? String(row.NO_STAMBUK) : '',
    name: row.NAMA || 'Tanpa Nama',
    kelasId: row.KELAS_ID || '', 
    kamar: row.KAMAR ? String(row.KAMAR) : null,
    tempatLahir: row.TEMPAT_LAHIR ? String(row.TEMPAT_LAHIR) : null,
    tanggalLahir: row.TANGGAL_LAHIR ? String(row.TANGGAL_LAHIR) : null,
    alamat: row.ALAMAT ? String(row.ALAMAT) : null,
    namaAyah: row.NAMA_AYAH ? String(row.NAMA_AYAH) : null,
    namaIbu: row.NAMA_IBU ? String(row.NAMA_IBU) : null,
    bagian: row.BAGIAN ? String(row.BAGIAN) : null,
    tahunMasuk: row.TAHUN_MASUK ? String(row.TAHUN_MASUK) : null,
    status: row.STATUS || 'Aktif',
    tahunKeluar: row.TAHUN_KELUAR ? String(row.TAHUN_KELUAR) : null,
  }));

  // Perform insert in batches or all at once (SQLite limits to 1000 usually)
  await db.insert(schema.siswi).values(rowsToInsert);
  return c.json({ success: true, count: rowsToInsert.length });
});

app.get('/api/v1/siswi/export', async (c) => {
  const db = drizzle(c.env.DB);
  const result = await db.select().from(schema.siswi);
  
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet('Data Siswi');
  
  const columns = [
    { header: 'NO_STAMBUK', key: 'nis', width: 20 },
    { header: 'NAMA', key: 'name', width: 30 },
    { header: 'KELAS_ID', key: 'kelasId', width: 20 },
    { header: 'KAMAR', key: 'kamar', width: 15 },
    { header: 'TEMPAT_LAHIR', key: 'tempatLahir', width: 20 },
    { header: 'TANGGAL_LAHIR', key: 'tanggalLahir', width: 20 },
    { header: 'ALAMAT', key: 'alamat', width: 30 },
    { header: 'NAMA_AYAH', key: 'namaAyah', width: 25 },
    { header: 'NAMA_IBU', key: 'namaIbu', width: 25 },
    { header: 'BAGIAN', key: 'bagian', width: 15 },
    { header: 'TAHUN_MASUK', key: 'tahunMasuk', width: 15 },
    { header: 'STATUS', key: 'status', width: 15 },
    { header: 'TAHUN_KELUAR', key: 'tahunKeluar', width: 15 }
  ];
  worksheet.columns = columns;

  const row = worksheet.getRow(1);
  row.eachCell((cell) => {
    cell.font = { bold: true, color: { argb: 'FFFFFFFF' } };
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF1E40AF' } };
  });

  result.forEach(r => worksheet.addRow(r));
  
  const buffer = await workbook.xlsx.writeBuffer();
  c.header('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  c.header('Content-Disposition', 'attachment; filename="Export_Data_Siswi_Mubtadiat.xlsx"');
  return c.body(buffer as any);
});

app.get('/api/v1/siswi', async (c) => {
  const db = drizzle(c.env.DB);
  const kelasId = c.req.query('kelasId');
  const mustahiqId = c.req.query('mustahiqId');
  
  if (mustahiqId) {
    const result = await db.select({
      id: schema.siswi.id,
      nis: schema.siswi.nis,
      name: schema.siswi.name,
      kelasId: schema.siswi.kelasId,
      kamar: schema.siswi.kamar,
      tempatLahir: schema.siswi.tempatLahir,
      tanggalLahir: schema.siswi.tanggalLahir,
      alamat: schema.siswi.alamat,
      namaAyah: schema.siswi.namaAyah,
      namaIbu: schema.siswi.namaIbu,
      bagian: schema.siswi.bagian,
      tahunMasuk: schema.siswi.tahunMasuk,
      status: schema.siswi.status,
      tahunKeluar: schema.siswi.tahunKeluar,
      customFields: schema.siswi.customFields,
    })
    .from(schema.siswi)
    .innerJoin(schema.kelas, eq(schema.siswi.kelasId, schema.kelas.id))
    .where(eq(schema.kelas.mustahiqId, mustahiqId));
    return c.json(result);
  }

  if (kelasId) {
    const result = await db.select().from(schema.siswi).where(eq(schema.siswi.kelasId, kelasId));
    return c.json(result);
  }
  const result = await db.select().from(schema.siswi);
  return c.json(result);
});

app.post('/api/v1/siswi', async (c) => {
  const db = drizzle(c.env.DB);
  try {
    const body = await c.req.json();
    const id = Date.now().toString();
    await db.insert(schema.siswi).values({
      id,
      nis: body.nis,
      name: body.name,
      kelasId: body.kelasId,
      kamar: body.kamar,
      tempatLahir: body.tempatLahir,
      tanggalLahir: body.tanggalLahir,
      alamat: body.alamat,
      namaAyah: body.namaAyah,
      namaIbu: body.namaIbu,
      bagian: body.bagian,
      tahunMasuk: body.tahunMasuk,
      status: body.status || 'Aktif',
      tahunKeluar: body.tahunKeluar,
      customFields: body.customFields,
    });
    return c.json({ message: 'Siswi created successfully', id }, 201);
  } catch (error: any) {
    return c.json({ error: error.message }, 500);
  }
});

app.put('/api/v1/siswi/:id', async (c) => {
  const db = drizzle(c.env.DB);
  try {
    const id = c.req.param('id');
    const body = await c.req.json();
    await db.update(schema.siswi).set({
      nis: body.nis,
      name: body.name,
      kelasId: body.kelasId,
      kamar: body.kamar,
      tempatLahir: body.tempatLahir,
      tanggalLahir: body.tanggalLahir,
      alamat: body.alamat,
      namaAyah: body.namaAyah,
      namaIbu: body.namaIbu,
      bagian: body.bagian,
      tahunMasuk: body.tahunMasuk,
      status: body.status,
      tahunKeluar: body.tahunKeluar,
      customFields: body.customFields,
    }).where(eq(schema.siswi.id, id));
    return c.json({ message: 'Siswi updated successfully' });
  } catch (error: any) {
    return c.json({ error: error.message }, 500);
  }
});

app.delete('/api/v1/siswi/:id', async (c) => {
  const db = drizzle(c.env.DB);
  const id = c.req.param('id');
  await db.delete(schema.siswi).where(eq(schema.siswi.id, id));
  return c.json({ success: true });
});

// --- SEED DUMMY DATA ---
app.post('/api/v1/seed', async (c) => {
  const db = drizzle(c.env.DB);
  
  // WIPE DATA (Reverse dependency order to avoid foreign key errors)
  await db.delete(schema.siswi);
  await db.delete(schema.kelas);
  await db.delete(schema.mapel);
  await db.delete(schema.jenjang);
  await db.delete(schema.semester);
  await db.delete(schema.tahunAjaran);
  await db.delete(schema.kamar);
  await db.delete(schema.bagian);
  await db.delete(schema.ekstrakurikuler);
  
  await db.delete(schema.jadwal);
  await db.delete(schema.tamrin);
  await db.delete(schema.pembagianGuru);
  await db.delete(schema.pembagianKelas);
  await db.delete(schema.mutasi);
  await db.delete(schema.validasiNilai);
  await db.delete(schema.kunciNilai);
  await db.delete(schema.erapor);
  await db.delete(schema.esertifikat);
  await db.delete(schema.hakAkses);
  
  await db.delete(schema.users);
  
  // 1. Seed Users (Roles: Admin, Mustahiq, Mufatish, Mundzir)
  const mustahiqs = ['mustahiq_1', 'mustahiq_2', 'mustahiq_3', 'mustahiq_4', 'mustahiq_5'];
  await db.insert(schema.users).values([
    { id: 'admin_1', username: 'admin', passwordHash: 'dummy', role: 'admin', fullName: 'Administrator Utama', createdAt: new Date() },
    ...mustahiqs.map((id, i) => ({ id, username: `mustahiq${i+1}`, passwordHash: 'dummy', role: 'mustahiq', fullName: `Ustadz Mustahiq ${i+1}`, createdAt: new Date() })),
    { id: 'mufatish_1', username: 'mufatish1', passwordHash: 'dummy', role: 'mufattish', fullName: 'Ustadz Mufatish 1', createdAt: new Date() },
    { id: 'mufatish_2', username: 'mufatish2', passwordHash: 'dummy', role: 'mufattish', fullName: 'Ustadz Mufatish 2', createdAt: new Date() },
    { id: 'mufatish_3', username: 'mufatish3', passwordHash: 'dummy', role: 'mufattish', fullName: 'Ustadzah Mufatish 3', createdAt: new Date() },
    { id: 'mundzir_1', username: 'mundzir1', passwordHash: 'dummy', role: 'mundzir', fullName: 'Ustadz Mundzir 1', createdAt: new Date() },
    { id: 'mundzir_2', username: 'mundzir2', passwordHash: 'dummy', role: 'mundzir', fullName: 'Ustadzah Mundzir 2', createdAt: new Date() },
    { id: 'mundzir_3', username: 'mundzir3', passwordHash: 'dummy', role: 'mundzir', fullName: 'Ustadz Mundzir 3', createdAt: new Date() },
  ]).onConflictDoNothing();

  // 2. Seed Master Data (Kamar, Bagian, Ekstrakurikuler)
  const kamars = ['A01', 'A02', 'B01', 'B02', 'C01', 'C02', 'D01'];
  await db.insert(schema.kamar).values(kamars.map((k) => ({ id: `kamar_${k}`, name: k })));
  
  const bagians = ['Tahfidz', 'Kitab Kuning', 'Bahasa Arab', 'Bahasa Inggris'];
  await db.insert(schema.bagian).values(bagians.map((b) => ({ id: `bagian_${b}`, name: b })));
  
  const ekskuls = ['Pramuka', 'Pencak Silat', 'Qiroah', 'Kaligrafi'];
  await db.insert(schema.ekstrakurikuler).values(ekskuls.map((e) => ({ id: `ekskul_${e}`, name: e })));

  // 3. Seed Jenjang & Kelas
  const jenjangs = [
    { id: 'jenjang_idad', name: "I'dadiyah", prefix: "I'dad" },
    { id: 'jenjang_ibtid', name: "Ibtida'iyyah", prefix: "Ibt" },
    { id: 'jenjang_tsana', name: "Tsanawiyah", prefix: "Tsan" },
    { id: 'jenjang_aliya', name: "Aliyah", prefix: "Aliy" }
  ];
  await db.insert(schema.jenjang).values(jenjangs.map(j => ({ id: j.id, name: j.name })));

  const classIds: string[] = [];
  let mIndex = 0;
  
  for (const j of jenjangs) {
    for (let i = 1; i <= 3; i++) {
      for (const char of ['A', 'B']) {
        const kId = `kelas_${j.prefix}_${i}${char}`;
        classIds.push(kId);
        await db.insert(schema.kelas).values({
          id: kId,
          name: `${i}${char} ${j.name}`,
          jenjangId: j.id,
          mustahiqId: mustahiqs[mIndex % mustahiqs.length],
        });
        mIndex++;
      }
    }
  }

  // 4. Seed 30 Siswi randomly distributed
  const names = ['Siti', 'Aisyah', 'Fatimah', 'Zahra', 'Nur', 'Hidayah', 'Aminah', 'Khadijah', 'Maryam', 'Rina', 'Dewi', 'Putri', 'Sari', 'Indah', 'Fitri'];
  for (let i = 0; i < 30; i++) {
    const kId = classIds[i % classIds.length];
    const kName = kamars[i % kamars.length];
    const bName = bagians[i % bagians.length];
    await db.insert(schema.siswi).values({
      id: `siswi_${i}`,
      nis: `100${i.toString().padStart(2, '0')}`,
      name: `${names[i % names.length]} ${names[(i+1) % names.length]}`,
      kelasId: kId,
      kamar: kName,
      tempatLahir: 'Jakarta',
      tanggalLahir: '2010-01-01',
      alamat: 'Asrama Pondok',
      namaAyah: 'Fulan',
      namaIbu: 'Fulanah',
      bagian: bName,
      tahunMasuk: '2024',
      status: 'Aktif'
    });
  }

  // 5. Seed other tables
  await db.insert(schema.tahunAjaran).values([
    { id: 'ta_1', name: '2024/2025', isActive: true },
    { id: 'ta_2', name: '2025/2026', isActive: false },
  ]);

  await db.insert(schema.semester).values([
    { id: 'sem_1', name: 'Ganjil', tahunAjaranId: 'ta_1', isActive: true },
    { id: 'sem_2', name: 'Genap', tahunAjaranId: 'ta_1', isActive: false },
  ]);

  await db.insert(schema.mapel).values([
    { id: 'mapel_1', name: 'Nahwu', jenjangId: 'jenjang_ibtid' },
    { id: 'mapel_2', name: 'Shorof', jenjangId: 'jenjang_ibtid' },
  ]);

  await db.insert(schema.jadwal).values([
    { id: 'jadwal_1', hari: 'Senin', waktu: '08:00', mapel: 'Nahwu', kelas: '1A Ibtida\'iyyah' },
  ]);

  await db.insert(schema.tamrin).values([
    { id: 'tamrin_1', name: 'Tamrin Akhir Ganjil', tanggal: '2024-12-10' },
  ]);

  await db.insert(schema.pembagianGuru).values([
    { id: 'pg_1', guru: 'Budi Santoso', tugas: 'Mengajar Nahwu' },
  ]);

  await db.insert(schema.pembagianKelas).values([
    { id: 'pk_1', kelas: '1A Ibtida\'iyyah', waliKelas: 'Ahmad Fauzi' },
  ]);

  await db.insert(schema.mutasi).values([
    { id: 'mut_1', siswa: 'Fulanah', jenis: 'Pindah', tanggal: '2024-10-01' },
  ]);

  await db.insert(schema.validasiNilai).values([
    { id: 'val_1', kelas: '1A Ibtida\'iyyah', status: 'Selesai Divalidasi' },
  ]);

  await db.insert(schema.kunciNilai).values([
    { id: 'kunci_1', semester: 'Ganjil 2024/2025', isLocked: true },
  ]);

  await db.insert(schema.erapor).values([
    { id: 'erapor_1', siswa: 'Siti Aisyah', semester: 'Ganjil', link: 'https://erapor.mubtadiaat.edu/view/1' },
  ]);

  await db.insert(schema.esertifikat).values([
    { id: 'esertifikat_1', siswa: 'Fatimah Zahra', kegiatan: 'Lomba Pidato', link: 'https://esertifikat.mubtadiaat.edu/view/1' },
  ]);

  await db.insert(schema.hakAkses).values([
    { id: 'hak_1', roleName: 'Admin', permissions: 'ALL' },
    { id: 'hak_2', roleName: 'Mustahiq', permissions: 'AKADEMIK, PENILAIAN' },
  ]);

  return c.json({ success: true, message: 'Database resetted and dummy data seeded successfully' });
});

const genericMap: Record<string, any> = {
  kamar: schema.kamar,
  bagian: schema.bagian,
  ekstrakurikuler: schema.ekstrakurikuler,
  'tahun-ajaran': schema.tahunAjaran,
  semester: schema.semester,
  jenjang: schema.jenjang,
  mapel: schema.mapel,
  jadwal: schema.jadwal,
  tamrin: schema.tamrin,
  'pembagian-guru': schema.pembagianGuru,
  'pembagian-kelas': schema.pembagianKelas,
  mutasi: schema.mutasi,
  'validasi-nilai': schema.validasiNilai,
  'kunci-nilai': schema.kunciNilai,
  'e-rapor': schema.erapor,
  'e-sertifikat': schema.esertifikat,
  'hak-akses': schema.hakAkses,
};

// --- GENERIC MASTER DATA CRUD (For Kamar, Bagian, dll) ---
app.get('/api/v1/:module', async (c) => {
  const mod = c.req.param('module');
  const db = drizzle(c.env.DB);
  if (genericMap[mod]) {
    return c.json(await db.select().from(genericMap[mod]));
  }
  return c.json([]); // Return empty list instead of 404
});

app.post('/api/v1/:module', async (c) => {
  const mod = c.req.param('module');
  const db = drizzle(c.env.DB);
  const body = await c.req.json();
  const id = Date.now().toString();
  if (genericMap[mod]) {
    await db.insert(genericMap[mod]).values({ ...body, id });
    return c.json({success:true, id});
  }
  return c.json({error: 'module not supported'}, 404);
});

app.put('/api/v1/:module/:id', async (c) => {
  const mod = c.req.param('module');
  const id = c.req.param('id');
  const db = drizzle(c.env.DB);
  const body = await c.req.json();
  if (genericMap[mod]) {
    await db.update(genericMap[mod]).set(body).where(eq(genericMap[mod].id, id));
    return c.json({success:true});
  }
  return c.json({error: 'module not supported'}, 404);
});

app.delete('/api/v1/:module/:id', async (c) => {
  const mod = c.req.param('module');
  const id = c.req.param('id');
  const db = drizzle(c.env.DB);
  if (genericMap[mod]) {
    // using raw query since dynamic where is tricky
    await db.delete(genericMap[mod]).where(eq(genericMap[mod].id, id)); 
    return c.json({success:true});
  }
  return c.json({error: 'module not supported'}, 404);
});

export default app;
