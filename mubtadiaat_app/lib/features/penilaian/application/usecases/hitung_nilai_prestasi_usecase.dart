import '../../domain/entities/nilai_akhir.dart';
import '../../domain/rules/perhitungan_nilai_rules.dart';
import '../../../../core/constants/status_prestasi.dart';

class HitungNilaiPrestasiUseCase {
  NilaiAkhir call(
    NilaiAkhir siswa,
    List<int> nilaiKhosSemester1,
    List<int> nilaiKhosSemester2,
  ) {
    final int prestasi = PerhitunganNilaiRules.hitungNilaiPrestasi(
      nilaiKhosSemester1,
      nilaiKhosSemester2,
      siswa.absenBiIdzni,
      siswa.absenBiGhoirihi,
    );
    
    final StatusPrestasi status = PerhitunganNilaiRules.tentukanStatusPrestasi(prestasi);

    return siswa.copyWith(
      nilaiPrestasi: prestasi,
      statusPrestasi: status,
    );
  }
}
