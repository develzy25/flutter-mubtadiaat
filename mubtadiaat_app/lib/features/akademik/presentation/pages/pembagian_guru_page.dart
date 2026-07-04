import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../shared/widgets/neu_button.dart';

class PembagianGuruPage extends ConsumerStatefulWidget {
  const PembagianGuruPage({super.key});

  @override
  ConsumerState<PembagianGuruPage> createState() => _PembagianGuruPageState();
}

class _PembagianGuruPageState extends ConsumerState<PembagianGuruPage> {
  // Mock data for UI demonstration
  final List<Map<String, dynamic>> dataList = [
    {'id': '1', 'guru': 'Ustadz Mustahiq 1', 'kelas': '1A Ibtida\'iyyah', 'mapel': 'Nahwu'},
    {'id': '2', 'guru': 'Ustadz Mustahiq 2', 'kelas': '2A Ibtida\'iyyah', 'mapel': 'Shorof'},
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
                  const Text('Tambah Pembagian Guru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                  const SizedBox(height: 20),
                  
                  const Text('Pilih Guru (Mustahiq)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildMockDropdown(['Ustadz Mustahiq 1', 'Ustadz Mustahiq 2', 'Ustadzah Mustahiq 3']),
                  
                  const SizedBox(height: 16),
                  const Text('Pilih Kelas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildMockDropdown(['1A Ibtida\'iyyah', '2A Ibtida\'iyyah', '3B Tsanawiyah']),
                  
                  const SizedBox(height: 16),
                  const Text('Pilih Mata Pelajaran', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildMockDropdown(['Nahwu', 'Shorof', 'Fiqih']),
                  
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
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembagian Guru tersimpan.')));
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
                Text('Pembagian Guru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                Text('Atur relasi guru, kelas, dan mapel', style: TextStyle(color: AppColors.textHintLight, fontSize: 11)),
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
                    DataColumn(label: Text('GURU', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('KELAS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('MATA PELAJARAN', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                    DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                  ],
                  rows: dataList.map((e) => DataRow(
                    cells: [
                      DataCell(Text(e['guru'].toString())),
                      DataCell(Text(e['kelas'].toString())),
                      DataCell(Text(e['mapel'].toString())),
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
