import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../shared/widgets/neu_button.dart';

class FinalisasiKelasPage extends StatelessWidget {
  final String kelasId;
  const FinalisasiKelasPage({super.key, required this.kelasId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      appBar: AppBar(
        title: const Text('Finalisasi Semester', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 15)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        toolbarHeight: 48,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: NeuContainer(
            padding: const EdgeInsets.all(24),
            borderRadius: 14,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_outline_rounded, size: 36, color: AppColors.warning),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Finalisasi Nilai Semester',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Peringatan: Setelah difinalisasi, nilai Khos akan dikunci dan nilai 'Am akan dihitung secara otomatis. Aksi ini tidak dapat dibatalkan kecuali oleh Admin.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight, height: 1.4),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: NeuButton(
                    color: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: 10,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Memproses finalisasi...'), duration: Duration(seconds: 1)),
                      );
                    },
                    child: const Center(
                      child: Text('FINALISASI SEKARANG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
