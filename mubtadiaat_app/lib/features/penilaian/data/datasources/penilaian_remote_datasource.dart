import '../models/nilai_dto.dart';

abstract class PenilaianRemoteDataSource {
  Future<List<NilaiMapelDto>> getNilaiKuartalByKelas(String kelasId, int kuartal);
  Future<void> saveNilaiKuartal(String kelasId, String mapelId, List<NilaiMapelDto> nilaiList);
  Future<void> finalisasiNilaiKelas(String kelasId, int semester);
}
