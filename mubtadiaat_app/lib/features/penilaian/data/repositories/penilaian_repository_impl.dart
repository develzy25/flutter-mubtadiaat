import '../../domain/entities/nilai_akhir.dart';
import '../../domain/entities/nilai_mapel.dart';
import '../../domain/repositories/penilaian_repository.dart';
import '../datasources/penilaian_remote_datasource.dart';
import '../models/nilai_dto.dart';

class PenilaianRepositoryImpl implements PenilaianRepository {
  final PenilaianRemoteDataSource remoteDataSource;

  PenilaianRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NilaiMapel>> getNilaiKuartalByKelas(String kelasId, int kuartal) async {
    final dtoList = await remoteDataSource.getNilaiKuartalByKelas(kelasId, kuartal);
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> saveNilaiKuartal(String kelasId, String mapelId, List<NilaiMapel> nilaiList) async {
    final dtoList = nilaiList.map((e) => NilaiMapelDto.fromEntity(e)).toList();
    await remoteDataSource.saveNilaiKuartal(kelasId, mapelId, dtoList);
  }

  @override
  Future<void> finalisasiNilaiKelas(String kelasId, int semester) async {
    await remoteDataSource.finalisasiNilaiKelas(kelasId, semester);
  }

  @override
  Future<List<NilaiAkhir>> getRaportKelas(String kelasId, int semester) async {
    // Mock data for Raport because backend is not ready yet
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
}
