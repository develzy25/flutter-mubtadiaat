import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../shared/widgets/neu_button.dart';
import '../../../../shared/widgets/neu_text_field.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/providers/role_provider.dart';

// --- Providers ---
final kelasProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await http.get(Uri.parse('$kBaseUrl/kelas'));
  if (response.statusCode == 200) return json.decode(response.body);
  throw Exception('Gagal memuat kelas');
});

final jenjangProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await http.get(Uri.parse('$kBaseUrl/jenjang'));
  if (response.statusCode == 200) return json.decode(response.body);
  throw Exception('Gagal memuat jenjang');
});

final mustahiqProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await http.get(Uri.parse('$kBaseUrl/users'));
  if (response.statusCode == 200) {
    final List<dynamic> users = json.decode(response.body);
    return users.where((u) => u['role'] == 'mustahiq').toList();
  }
  throw Exception('Gagal memuat mustahiq');
});

class DataKelasPage extends ConsumerStatefulWidget {
  const DataKelasPage({super.key});

  @override
  ConsumerState<DataKelasPage> createState() => _DataKelasPageState();
}

class _DataKelasPageState extends ConsumerState<DataKelasPage> {
  // Provider for fetching data
  final kelasListProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
    final role = ref.watch(roleProvider);
    final api = ref.watch(apiServiceProvider);
    
    // Asumsikan mustahiq memiliki ID 'mustahiq_1' pada demo ini
    // Di aplikasi nyata, ID ini akan diambil dari token login/session
    String endpoint = '/kelas';
    if (role == AppRole.mustahiq) {
      endpoint += '?mustahiqId=mustahiq_1';
    }
    
    final response = await api.get(endpoint);
    return response.data as List<dynamic>;
  });

  void _showFormDialog({Map<String, dynamic>? kelasData, List<dynamic>? jenjangList, List<dynamic>? mustahiqList}) {
    if (jenjangList == null || jenjangList.isEmpty || mustahiqList == null || mustahiqList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Jenjang dan Mustahiq (Guru) harus tersedia terlebih dahulu.')),
      );
      return;
    }

    final isEdit = kelasData != null;
    final nameCtrl = TextEditingController(text: isEdit ? kelasData['name'] : '');
    String selectedJenjang = isEdit ? kelasData['jenjangId'] : jenjangList.first['id'];
    String selectedMustahiq = isEdit ? kelasData['mustahiqId'] : mustahiqList.first['id'];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateBuilder) {
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
                      Text(isEdit ? 'Edit Kelas' : 'Tambah Kelas', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                      const SizedBox(height: 20),
                      NeuTextField(label: 'Nama Kelas', hint: 'Contoh: 1A', controller: nameCtrl),
                      const SizedBox(height: 16),
                      const Text('Jenjang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedJenjang,
                            isExpanded: true,
                            items: jenjangList.map<DropdownMenuItem<String>>((j) {
                              return DropdownMenuItem(value: j['id'], child: Text(j['name']));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setStateBuilder(() => selectedJenjang = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Wali Kelas (Mustahiq)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedMustahiq,
                            isExpanded: true,
                            items: mustahiqList.map<DropdownMenuItem<String>>((m) {
                              return DropdownMenuItem(value: m['id'], child: Text(m['fullName']));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setStateBuilder(() => selectedMustahiq = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
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
                            onPressed: () async {
                              final body = {
                                'name': nameCtrl.text,
                                'jenjangId': selectedJenjang,
                                'mustahiqId': selectedMustahiq,
                              };
                              
                              final url = isEdit ? '$kBaseUrl/kelas/${kelasData['id']}' : '$kBaseUrl/kelas';
                              final req = isEdit 
                                  ? http.put(Uri.parse(url), body: json.encode(body))
                                  : http.post(Uri.parse(url), body: json.encode(body));
                              
                              await req;
                              if (!context.mounted) return;
                              Navigator.pop(ctx);
                              ref.invalidate(kelasProvider);
                            },
                            child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }

  void _deleteKelas(String id) async {
    await http.delete(Uri.parse('$kBaseUrl/kelas/$id'));
    ref.invalidate(kelasProvider);
  }

  String _getJenjangName(List<dynamic>? jenjangList, String? id) {
    if (id == null) return '-';
    if (jenjangList == null) return id;
    final found = jenjangList.where((j) => j['id'] == id).toList();
    return found.isNotEmpty ? (found.first['name'] as String? ?? id) : id;
  }

  String _getMustahiqName(List<dynamic>? mustahiqList, String? id) {
    if (id == null) return '-';
    if (mustahiqList == null) return id;
    final found = mustahiqList.where((m) => m['id'] == id).toList();
    return found.isNotEmpty ? (found.first['fullName'] as String? ?? id) : id;
  }

  @override
  Widget build(BuildContext context) {
    final kelasState = ref.watch(kelasProvider);
    final jenjangState = ref.watch(jenjangProvider);
    final mustahiqState = ref.watch(mustahiqProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data Kelas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                SizedBox(height: 4),
                Text('Kelola kelas, jenjang, dan penugasan wali kelas (Mustahiq).', style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight)),
              ],
            ),
            NeuButton(
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              onPressed: () {
                _showFormDialog(
                  jenjangList: jenjangState.value,
                  mustahiqList: mustahiqState.value,
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Tambah Kelas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: NeuContainer(
            padding: EdgeInsets.zero,
            child: kelasState.when(
              data: (kelasList) {
                if (kelasList.isEmpty) {
                  return const Center(child: Text('Belum ada data kelas.', style: TextStyle(color: AppColors.textHintLight)));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: kelasList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderLight),
                  itemBuilder: (context, index) {
                    final kelas = kelasList[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.premiumGold.withValues(alpha: 0.2),
                        child: const Icon(Icons.class_rounded, color: AppColors.premiumGold, size: 20),
                      ),
                      title: Text(kelas['name'] as String? ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryDark)),
                      subtitle: Text(
                        'Jenjang: ${_getJenjangName(jenjangState.value, kelas['jenjangId'])} • Wali: ${_getMustahiqName(mustahiqState.value, kelas['mustahiqId'])}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 20),
                            onPressed: () => _showFormDialog(
                              kelasData: kelas,
                              jenjangList: jenjangState.value,
                              mustahiqList: mustahiqState.value,
                            ),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                            onPressed: () => _deleteKelas(kelas['id']),
                            tooltip: 'Hapus',
                          ),
                        ],
                      ),
                    ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Gagal memuat: $err', style: const TextStyle(color: Colors.red))),
            ),
          ),
        ),
      ],
    );
  }
}
