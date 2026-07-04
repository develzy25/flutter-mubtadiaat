import 'nilai_mapel.dart';
import '../../../../core/constants/status_prestasi.dart';

class NilaiAkhir {
  final String studentId;
  final String studentName;
  final int semester; // 1 or 2
  final List<NilaiMapel> nilaiMapelList;
  final int nilaiAkhlaq;
  final int absenBiIdzni;
  final int absenBiGhoirihi;
  final int? nilaiPrestasi;
  final StatusPrestasi statusPrestasi;

  const NilaiAkhir({
    required this.studentId,
    required this.studentName,
    required this.semester,
    required this.nilaiMapelList,
    this.nilaiAkhlaq = 8,
    this.absenBiIdzni = 0,
    this.absenBiGhoirihi = 0,
    this.nilaiPrestasi,
    this.statusPrestasi = StatusPrestasi.none,
  });

  NilaiAkhir copyWith({
    String? studentId,
    String? studentName,
    int? semester,
    List<NilaiMapel>? nilaiMapelList,
    int? nilaiAkhlaq,
    int? absenBiIdzni,
    int? absenBiGhoirihi,
    int? nilaiPrestasi,
    StatusPrestasi? statusPrestasi,
  }) {
    return NilaiAkhir(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      semester: semester ?? this.semester,
      nilaiMapelList: nilaiMapelList ?? this.nilaiMapelList,
      nilaiAkhlaq: nilaiAkhlaq ?? this.nilaiAkhlaq,
      absenBiIdzni: absenBiIdzni ?? this.absenBiIdzni,
      absenBiGhoirihi: absenBiGhoirihi ?? this.absenBiGhoirihi,
      nilaiPrestasi: nilaiPrestasi ?? this.nilaiPrestasi,
      statusPrestasi: statusPrestasi ?? this.statusPrestasi,
    );
  }
}
