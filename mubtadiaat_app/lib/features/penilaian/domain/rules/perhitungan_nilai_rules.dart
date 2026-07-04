import '../../../../core/constants/status_prestasi.dart';

class PerhitunganNilaiRules {
  /// Pembulatan khusus sesuai pedoman:
  /// x.0 - x.4 -> turun
  /// x.5 - x.9 -> naik
  static int pembulatan(double nilai) {
    return nilai.round();
  }

  /// Cek apakah mapel adalah Al-Qur'an atau Akhlaq
  static bool isQuranAtauAkhlaq(String mapelName) {
    final lower = mapelName.toLowerCase();
    return lower.contains('qur\'an') || lower.contains('akhlaq') || lower.contains('quran') ||
           mapelName.contains('القرآن') || mapelName.contains('الأخلاق');
  }

  /// Validasi nilai berdasar mapel
  static String? validasiInputNilai(double? nilai, String mapelName) {
    if (nilai == null) return null;
    
    if (isQuranAtauAkhlaq(mapelName)) {
      if (nilai > 8.0) return 'Nilai maksimal untuk mapel ini adalah 8';
    } else {
      if (nilai > 10.0) return 'Nilai maksimal untuk mapel ini adalah 10';
    }
    
    if (nilai < 0) return 'Nilai minimal adalah 0';
    
    return null;
  }

  /// Menghitung Nilai Khos (Semester 1 atau 2)
  static int hitungNilaiKhos(double? nilaiTamrin, double? nilaiUjian) {
    // Jika tidak ada nilai tamrin, maka nilai ujian dibagi 2
    if (nilaiTamrin == null) {
      if (nilaiUjian == null) return 4; // Minimal 4 sesuai aturan
      return pembulatan(nilaiUjian / 2).clamp(4, 9);
    }
    
    if (nilaiUjian == null) {
      return pembulatan(nilaiTamrin / 2).clamp(4, 9);
    }

    final double rataRata = (nilaiTamrin + nilaiUjian) / 2;
    return pembulatan(rataRata).clamp(4, 9);
  }

  /// Menghitung Nilai 'Am untuk satu kelas per mata pelajaran
  static int hitungNilaiAm(List<int> daftarNilaiKhos, int jumlahSiswiAktif) {
    if (jumlahSiswiAktif == 0 || daftarNilaiKhos.isEmpty) return 4;
    
    int total = daftarNilaiKhos.fold(0, (sum, nilai) => sum + nilai);
    double rataRata = total / jumlahSiswiAktif;
    return pembulatan(rataRata).clamp(4, 9);
  }

  /// Menghitung nilai prestasi (Al-Bayan) berdasarkan Nilai Khos Semester 1 dan 2
  static int hitungNilaiPrestasi(
    List<int> nilaiKhosSemester1,
    List<int> nilaiKhosSemester2,
    int absenBiIdzni,
    int absenBiGhoirihi,
  ) {
    final int totalMataPelajaran = nilaiKhosSemester1.length + nilaiKhosSemester2.length;
    if (totalMataPelajaran == 0) return 0;

    final int totalNilaiSemester1 = nilaiKhosSemester1.fold(0, (sum, val) => sum + val);
    final int totalNilaiSemester2 = nilaiKhosSemester2.fold(0, (sum, val) => sum + val);
    final int totalSemuaNilai = totalNilaiSemester1 + totalNilaiSemester2;

    // Hitung rata-rata dan bulatkan ke bawah (biasanya prestasi round/floor? Aturan bilang `[] - floor`)
    final double rataRata = totalSemuaNilai / totalMataPelajaran;
    
    // Asumsi nilai awal dibulatkan standard
    int nilaiPrestasiAwal = pembulatan(rataRata);

    // Pengurangan akibat absensi (pembulatan ke bawah = floor)
    final int kurangBiIdzni = (absenBiIdzni / 15).floor();
    final int kurangBiGhoirihi = (absenBiGhoirihi / 5).floor();

    return nilaiPrestasiAwal - kurangBiIdzni - kurangBiGhoirihi;
  }

  /// Menentukan status prestasi dari nilai prestasi yang sudah dihitung
  static StatusPrestasi tentukanStatusPrestasi(int nilaiPrestasi) {
    if (nilaiPrestasi >= 9) return StatusPrestasi.jayyidAwwal;
    if (nilaiPrestasi == 8) return StatusPrestasi.jayyidTsani;
    if (nilaiPrestasi == 7) return StatusPrestasi.mutawassithAwwal;
    if (nilaiPrestasi == 6) return StatusPrestasi.mutawassithTsani;
    return StatusPrestasi.rodi;
  }
}
