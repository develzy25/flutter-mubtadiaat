import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nilai_mapel.dart';
import '../../domain/repositories/penilaian_repository.dart';
import '../../data/repositories/penilaian_repository_impl.dart';
import '../../data/datasources/penilaian_remote_datasource.dart';
import '../../data/models/nilai_dto.dart';
import '../../application/usecases/hitung_nilai_khos_usecase.dart';

// Mock Datasource since backend is not ready
class MockPenilaianDataSource implements PenilaianRemoteDataSource {
  @override
  Future<List<NilaiMapelDto>> getNilaiKuartalByKelas(String kelasId, int kuartal) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      NilaiMapelDto(id: '1', mapelId: 'm1', mapelName: 'تحفة الأطفال \\ القرآن', nilaiTamrin: 8.0, nilaiUjian: 7.5),
      NilaiMapelDto(id: '2', mapelId: 'm2', mapelName: 'الأخلاق', nilaiTamrin: 7.0, nilaiUjian: 7.5),
      NilaiMapelDto(id: '3', mapelId: 'm3', mapelName: 'فتح المبين', nilaiTamrin: 6.5, nilaiUjian: 8.5),
      NilaiMapelDto(id: '4', mapelId: 'm4', mapelName: 'الخط \\ الإملاء', nilaiTamrin: 9.0, nilaiUjian: 9.0),
      NilaiMapelDto(id: '5', mapelId: 'm5', mapelName: 'تسهيل الطرقات', nilaiTamrin: 8.5, nilaiUjian: 8.0),
      NilaiMapelDto(id: '6', mapelId: 'm6', mapelName: 'رياض الصالحين', nilaiTamrin: 7.5, nilaiUjian: 8.0),
    ];
  }

  @override
  Future<void> saveNilaiKuartal(String kelasId, String mapelId, List<NilaiMapelDto> nilaiList) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> finalisasiNilaiKelas(String kelasId, int semester) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

final penilaianRepositoryProvider = Provider<PenilaianRepository>((ref) {
  return PenilaianRepositoryImpl(MockPenilaianDataSource());
});

final hitungNilaiKhosUseCaseProvider = Provider<HitungNilaiKhosUseCase>((ref) {
  return HitungNilaiKhosUseCase();
});

final nilaiMapelListProvider = FutureProvider.family<List<NilaiMapel>, String>((ref, kelasId) async {
  final repo = ref.watch(penilaianRepositoryProvider);
  final usecase = ref.watch(hitungNilaiKhosUseCaseProvider);
  
  final list = await repo.getNilaiKuartalByKelas(kelasId, 1);
  return list.map((e) => usecase(e)).toList();
});
