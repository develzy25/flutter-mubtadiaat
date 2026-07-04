import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../../core/providers/role_provider.dart';
import '../../../../core/services/api_service.dart';

class PilihKelasPage extends ConsumerWidget {
  final String action;

  const PilihKelasPage({super.key, required this.action});

  String _getTitle() {
    switch (action) {
      case 'input': return 'Input Nilai';
      case 'akhlaq': return 'Input Akhlaq';
      case 'finalisasi': return 'Finalisasi';
      case 'raport': return 'Cetak Raport';
      case 'albayan': return 'Cetak Al-Bayan';
      case 'kehadiran': return 'Kehadiran Siswi';
      case 'catatan': return 'Catatan Siswi';
      case 'tamrin': return 'Input Tamrin';
      case 'kelas': return 'Kelas Mengajar';
      default: return 'Pilih Kelas';
    }
  }

  void _onKelasTapped(BuildContext context, String kelasId) {
    if (action == 'input') {
      context.push('/penilaian/input/$kelasId');
    } else if (action == 'finalisasi') {
      context.push('/penilaian/finalisasi/$kelasId');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fitur ${_getTitle()} untuk $kelasId segera hadir!'), duration: const Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final AsyncValue<List<dynamic>> kelasAsync;

    if (role == AppRole.mustahiq) {
      kelasAsync = ref.watch(mustahiqKelasProvider);
    } else {
      kelasAsync = ref.watch(genericListProvider('/kelas'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      appBar: AppBar(
        title: Text(_getTitle(), style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 15)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        toolbarHeight: 48,
      ),
      body: kelasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        data: (kelasList) {
          if (kelasList.isEmpty) {
            return const Center(child: Text('Belum ada data kelas.', style: TextStyle(color: AppColors.textSecondaryLight)));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            itemCount: kelasList.length,
            itemBuilder: (context, index) {
              final kelas = kelasList[index];
              final id = kelas['id']?.toString() ?? '';
              final nama = kelas['name']?.toString() ?? 'Kelas';
              // If mapel exists in API response, use it. Otherwise empty string.
              final mapel = kelas['mapel']?.toString() ?? ''; 

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => _onKelasTapped(context, id),
                  borderRadius: BorderRadius.circular(12),
                  child: NeuContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    borderRadius: 12,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.class_rounded, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nama, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              if (mapel.isNotEmpty)
                                Text(mapel, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
                              if (mapel.isEmpty)
                                const Text('32 Siswi Aktif', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textHintLight, size: 18),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
