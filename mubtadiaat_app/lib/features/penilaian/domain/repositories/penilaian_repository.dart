import '../entities/nilai_akhir.dart';
import '../entities/nilai_mapel.dart';

abstract class PenilaianRepository {
  Future<List<NilaiMapel>> getNilaiKuartalByKelas(String kelasId, int kuartal);
  Future<void> saveNilaiKuartal(String kelasId, String mapelId, List<NilaiMapel> nilaiList);
  
  /// Finalisasi nilai untuk satu kelas, mengunci nilai khos dan menghitung nilai 'am
  Future<void> finalisasiNilaiKelas(String kelasId, int semester);
  
  Future<List<NilaiAkhir>> getRaportKelas(String kelasId, int semester);
}
