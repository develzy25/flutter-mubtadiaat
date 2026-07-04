import '../../domain/repositories/penilaian_repository.dart';

class FinalisasiKelasUseCase {
  final PenilaianRepository repository;

  FinalisasiKelasUseCase(this.repository);

  Future<void> call(String kelasId, int semester) async {
    return repository.finalisasiNilaiKelas(kelasId, semester);
  }
}
