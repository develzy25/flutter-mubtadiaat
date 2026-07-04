import '../../domain/entities/nilai_mapel.dart';
import '../../domain/rules/perhitungan_nilai_rules.dart';

class HitungNilaiKhosUseCase {
  NilaiMapel call(NilaiMapel nilaiLama) {
    final nilaiKhos = PerhitunganNilaiRules.hitungNilaiKhos(
      nilaiLama.nilaiTamrin,
      nilaiLama.nilaiUjian,
    );
    return nilaiLama.copyWith(nilaiKhos: nilaiKhos);
  }
}
