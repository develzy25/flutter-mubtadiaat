import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nilai_mapel.dart';
import '../../domain/rules/perhitungan_nilai_rules.dart';
import 'penilaian_provider.dart';

class InputNilaiState {
  final bool isLoading;
  final String? error;
  final List<NilaiMapel> nilaiList;
  // Menyimpan Mapel ID yang mana saja yang manual override nilai khos nya
  final Set<String> overriddenKhosMapelIds;

  InputNilaiState({
    this.isLoading = true,
    this.error,
    this.nilaiList = const [],
    this.overriddenKhosMapelIds = const {},
  });

  InputNilaiState copyWith({
    bool? isLoading,
    String? error,
    List<NilaiMapel>? nilaiList,
    Set<String>? overriddenKhosMapelIds,
  }) {
    return InputNilaiState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      nilaiList: nilaiList ?? this.nilaiList,
      overriddenKhosMapelIds: overriddenKhosMapelIds ?? this.overriddenKhosMapelIds,
    );
  }
}

class InputNilaiController extends StateNotifier<InputNilaiState> {
  final Ref _ref;
  final String _kelasId;

  InputNilaiController(this._ref, this._kelasId) : super(InputNilaiState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final list = await _ref.read(penilaianRepositoryProvider).getNilaiKuartalByKelas(_kelasId, 1);
      
      // Hitung Khos Awal untuk semuanya
      final initialList = list.map((e) {
        final khos = PerhitunganNilaiRules.hitungNilaiKhos(e.nilaiTamrin, e.nilaiUjian);
        return e.copyWith(nilaiKhos: khos);
      }).toList();

      state = state.copyWith(isLoading: false, nilaiList: initialList);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateTamrin(String mapelId, double? value) {
    _updateNilai(mapelId, tamrin: value);
  }

  void updateUjian(String mapelId, double? value) {
    _updateNilai(mapelId, ujian: value);
  }

  void updateKhosManual(String mapelId, int? value) {
    if (value == null) {
      // User menghapus manual override, kembalikan ke auto-calc
      final newSet = Set<String>.from(state.overriddenKhosMapelIds)..remove(mapelId);
      state = state.copyWith(overriddenKhosMapelIds: newSet);
      
      // Trigger update buat recalculate
      final currentMapel = state.nilaiList.firstWhere((e) => e.mapelId == mapelId);
      _updateNilai(mapelId, tamrin: currentMapel.nilaiTamrin, ujian: currentMapel.nilaiUjian);
    } else {
      // User set manual override
      final newSet = Set<String>.from(state.overriddenKhosMapelIds)..add(mapelId);
      
      final updatedList = state.nilaiList.map((e) {
        if (e.mapelId == mapelId) {
          return e.copyWith(nilaiKhos: value);
        }
        return e;
      }).toList();
      
      state = state.copyWith(nilaiList: updatedList, overriddenKhosMapelIds: newSet);
    }
  }

  void _updateNilai(String mapelId, {double? tamrin, double? ujian}) {
    final updatedList = state.nilaiList.map((e) {
      if (e.mapelId == mapelId) {
        final newTamrin = tamrin ?? e.nilaiTamrin;
        final newUjian = ujian ?? e.nilaiUjian;
        
        int? newKhos = e.nilaiKhos;
        
        // Auto calculate khos JIKA TIDAK ada override manual
        if (!state.overriddenKhosMapelIds.contains(mapelId)) {
          newKhos = PerhitunganNilaiRules.hitungNilaiKhos(newTamrin, newUjian);
        }
        
        return e.copyWith(
          nilaiTamrin: newTamrin,
          nilaiUjian: newUjian,
          nilaiKhos: newKhos,
        );
      }
      return e;
    }).toList();

    state = state.copyWith(nilaiList: updatedList);
  }
}

final inputNilaiControllerProvider = StateNotifierProvider.family<InputNilaiController, InputNilaiState, String>((ref, kelasId) {
  return InputNilaiController(ref, kelasId);
});
