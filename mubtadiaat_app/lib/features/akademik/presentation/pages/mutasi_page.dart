import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../shared/widgets/neu_button.dart';

class MutasiPage extends ConsumerStatefulWidget {
  const MutasiPage({super.key});

  @override
  ConsumerState<MutasiPage> createState() => _MutasiPageState();
}

class _MutasiPageState extends ConsumerState<MutasiPage> {
  // Mock data for UI demonstration
  final List<Map<String, dynamic>> dataList = [
    {'id': '1', 'siswa': 'Siti Aisyah', 'jenis': 'Pindah Kelas', 'tanggal': '2024-06-15', 'status': 'Selesai'},
    {'id': '2', 'siswa': 'Fatimah Zahra', 'jenis': 'Keluar Pondok', 'tanggal': '2024-10-01', 'status': 'Menunggu Persetujuan'},
  ];

  void _showCustomFormModal() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: NeuContainer(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Catat Mutasi Siswi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                  const SizedBox(height: 20),
                  
                  const Text('Pilih Siswi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildMockDropdown(['Siti Aisyah', 'Fatimah Zahra', 'Nur Hidayah']),
                  
                  const SizedBox(height: 16),
                  const Text('Jenis Mutasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildMockDropdown(['Pindah Kelas', 'Pindah Jenjang', 'Keluar Pondok', 'Cuti']),
                  
                  const SizedBox(height: 16),
                  const Text('Keterangan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukkan alasan / tujuan mutasi',
                      hintStyle: TextStyle(fontSize: 13, color: AppColors.textHintLight)
                    ),
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Batal', style: TextStyle(color: AppColors.textHintLight)),
                      ),
                      const SizedBox(width: 12),
                      NeuButton(
                        color: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        borderRadius: 12,
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data Mutasi tersimpan.')));
                        },
                        child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMockDropdown(List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.first,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mutasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                Text('Kelola perpindahan kelas, jenjang, atau status keluar', style: TextStyle(color: AppColors.textHintLight, fontSize: 11)),
              ],
            ),
            NeuButton(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              borderRadius: 10,
              onPressed: _showCustomFormModal,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: AppColors.primary, size: 16),
                  SizedBox(width: 4),
                  Text('Tambah', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: NeuContainer(
            padding: const EdgeInsets.all(14),
            borderRadius: 14,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 30,
                  headingRowHeight: 40,
                  columns: const [
                    DataColumn(label: Text('SISWI', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('JENIS MUTASI', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('TANGGAL', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                  ],
                  rows: dataList.map((e) => DataRow(
                    cells: [
                      DataCell(Text(e['siswa'].toString())),
                      DataCell(Text(e['jenis'].toString())),
                      DataCell(Text(e['tanggal'].toString())),
                      DataCell(Text(e['status'].toString())),
                      DataCell(Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.delete_rounded, size: 18, color: Colors.redAccent), onPressed: (){}),
                        ],
                      )),
                    ],
                  )).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
