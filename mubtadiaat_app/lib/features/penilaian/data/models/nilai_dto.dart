import '../../domain/entities/nilai_mapel.dart';

class NilaiMapelDto {
  final String id;
  final String mapelId;
  final String mapelName;
  final double? nilaiTamrin;
  final double? nilaiUjian;
  final int? nilaiKhos;

  NilaiMapelDto({
    required this.id,
    required this.mapelId,
    required this.mapelName,
    this.nilaiTamrin,
    this.nilaiUjian,
    this.nilaiKhos,
  });

  factory NilaiMapelDto.fromJson(Map<String, dynamic> json) {
    return NilaiMapelDto(
      id: json['id'] as String,
      mapelId: json['mapelId'] as String,
      mapelName: json['mapelName'] as String,
      nilaiTamrin: json['nilaiTamrin'] != null ? (json['nilaiTamrin'] as num).toDouble() : null,
      nilaiUjian: json['nilaiUjian'] != null ? (json['nilaiUjian'] as num).toDouble() : null,
      nilaiKhos: json['nilaiKhos'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mapelId': mapelId,
      'mapelName': mapelName,
      'nilaiTamrin': nilaiTamrin,
      'nilaiUjian': nilaiUjian,
      'nilaiKhos': nilaiKhos,
    };
  }

  NilaiMapel toEntity() {
    return NilaiMapel(
      id: id,
      mapelId: mapelId,
      mapelName: mapelName,
      nilaiTamrin: nilaiTamrin,
      nilaiUjian: nilaiUjian,
      nilaiKhos: nilaiKhos,
    );
  }

  static NilaiMapelDto fromEntity(NilaiMapel entity) {
    return NilaiMapelDto(
      id: entity.id,
      mapelId: entity.mapelId,
      mapelName: entity.mapelName,
      nilaiTamrin: entity.nilaiTamrin,
      nilaiUjian: entity.nilaiUjian,
      nilaiKhos: entity.nilaiKhos,
    );
  }
}
