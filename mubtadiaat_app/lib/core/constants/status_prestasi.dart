enum StatusPrestasi {
  jayyidAwwal('JA', 'جَيِّدٌ أَوَّل', 'Jayyid Awwal', 1),
  jayyidTsani('JT', 'جَيِّدٌ ثَانٍ', 'Jayyid Tsani', 2),
  mutawassithAwwal('MA', 'مُتَوَسِّطٌ أَوَّل', 'Mutawasith Awwal', 3),
  mutawassithTsani('MT', 'مُتَوَسِّطٌ ثَانٍ', 'Mutawasith Tsani', 4),
  rodi('RD', 'رَدِيء', 'Radī’ (Rodi\')', 5),
  mutsbat('MS', 'مُثْبَت', 'Mutsbat', 6),
  none('', '', '', 99);

  final String kode;
  final String arab;
  final String latin;
  final int urutan;

  const StatusPrestasi(this.kode, this.arab, this.latin, this.urutan);
}
