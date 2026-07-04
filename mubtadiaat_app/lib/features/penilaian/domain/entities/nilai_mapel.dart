class NilaiMapel {
  final String id;
  final String mapelId;
  final String mapelName;
  final double? nilaiTamrin; // Kuartal 1 or 3
  final double? nilaiUjian;  // Kuartal 2 or 4
  final int? nilaiKhos; // Calculated and rounded value

  const NilaiMapel({
    required this.id,
    required this.mapelId,
    required this.mapelName,
    this.nilaiTamrin,
    this.nilaiUjian,
    this.nilaiKhos,
  });

  NilaiMapel copyWith({
    String? id,
    String? mapelId,
    String? mapelName,
    double? nilaiTamrin,
    double? nilaiUjian,
    int? nilaiKhos,
  }) {
    return NilaiMapel(
      id: id ?? this.id,
      mapelId: mapelId ?? this.mapelId,
      mapelName: mapelName ?? this.mapelName,
      nilaiTamrin: nilaiTamrin ?? this.nilaiTamrin,
      nilaiUjian: nilaiUjian ?? this.nilaiUjian,
      nilaiKhos: nilaiKhos ?? this.nilaiKhos,
    );
  }
}
