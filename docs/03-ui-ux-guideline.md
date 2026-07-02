# 03. UI/UX Guidelines - Mobile & Responsive

## Aturan Utama Tata Letak
1. **Zero Unwanted Scroll (No Overflow Leak)**:
   - Menggunakan `min-h-dvh` (dynamic viewport height) untuk penampung utama.
   - Elemen dekorasi blur diisolasi dengan `fixed inset-0 overflow-hidden pointer-events-none`.
2. **Auto Zoom Prevention**:
   - `index.html` dikunci dengan `maximum-scale=1.0, user-scalable=no` untuk mencegah auto-zoom mengganggu pada Safari iOS / Chrome Android.
3. **Touch-Friendly Hit Targets**:
   - Ukuran minimum tombol & input adalah `44px x 44px`.
   - Sudut melengkung (*border-radius*) menggunakan `rounded-2xl` atau `rounded-3xl`.
4. **Sentuhan Ornamen Elegan (Pondok Putri)**:
   - Menggunakan divider aksen batik minimalis sebagai pemisah visual tanpa membebani layar.
