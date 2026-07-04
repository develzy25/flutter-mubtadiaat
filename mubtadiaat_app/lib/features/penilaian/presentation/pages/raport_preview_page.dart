import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';

class RaportPreviewPage extends StatelessWidget {
  final String studentId;
  const RaportPreviewPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      appBar: AppBar(
        title: const Text('Preview Raport', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 15)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        toolbarHeight: 48,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        children: [
          NeuContainer(
            padding: const EdgeInsets.all(14),
            borderRadius: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Data Siswi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                const Divider(height: 20),
                _buildInfoRow('Nama', 'Fatimah'),
                _buildInfoRow('Kelas', "Ibtida'iyyah VI"),
                _buildInfoRow('Semester', 'I (Satu)'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NeuContainer(
            padding: const EdgeInsets.all(14),
            borderRadius: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nilai Akademik', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                const Divider(height: 20),
                _buildScoreHeader(),
                const Divider(height: 8),
                _buildScoreRow("Al-Qur'an", '8', '-'),
                _buildScoreRow('Akhlaq', '8', '-'),
                _buildScoreRow('Nahwu', '7', '7'),
                _buildScoreRow('Fiqih', '9', '8'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryDark)),
        ],
      ),
    );
  }

  Widget _buildScoreHeader() {
    return const Row(
      children: [
        Expanded(child: Text('Mata Pelajaran', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.textHintLight))),
        SizedBox(width: 60, child: Text('Khos', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.primary))),
        SizedBox(width: 60, child: Text("'Am", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.textSecondaryLight))),
      ],
    );
  }

  Widget _buildScoreRow(String mapel, String khos, String am) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(mapel, style: const TextStyle(fontSize: 13))),
          SizedBox(
            width: 60,
            child: Text(khos, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary)),
          ),
          SizedBox(
            width: 60,
            child: Text(am, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight)),
          ),
        ],
      ),
    );
  }
}
