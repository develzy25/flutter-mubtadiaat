import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../shared/widgets/neu_button.dart';
import '../../../../shared/widgets/neu_text_field.dart';
import '../../../../core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data_kelas_page.dart'; // To reuse kelasProvider

import '../../../../core/providers/role_provider.dart'; // To get roleProvider

// --- Providers ---
final siswiProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final role = ref.watch(roleProvider);
  final api = ref.watch(apiServiceProvider);
  
  String endpoint = '/siswi';
  if (role == AppRole.mustahiq) {
    endpoint += '?mustahiqId=mustahiq_1';
  }
  
  final response = await api.get(endpoint);
  return response.data as List<dynamic>;
});

class DataSiswiPage extends ConsumerStatefulWidget {
  const DataSiswiPage({super.key});
  @override
  ConsumerState<DataSiswiPage> createState() => _DataSiswiPageState();
}

class _DataSiswiPageState extends ConsumerState<DataSiswiPage> {
  void _showFormDialog({Map<String, dynamic>? siswiData, List<dynamic>? kelasList}) {
    if (kelasList == null || kelasList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data Kelas harus tersedia terlebih dahulu. Buka menu Kelas untuk menambah.')),
      );
      return;
    }

    final isEdit = siswiData != null;
    final nisCtrl = TextEditingController(text: isEdit ? siswiData['nis'] : '');
    final nameCtrl = TextEditingController(text: isEdit ? siswiData['name'] : '');
    final kamarCtrl = TextEditingController(text: isEdit ? siswiData['kamar'] : '');
    final tempatLahirCtrl = TextEditingController(text: isEdit ? siswiData['tempatLahir'] : '');
    final tanggalLahirCtrl = TextEditingController(text: isEdit ? siswiData['tanggalLahir'] : '');
    final alamatCtrl = TextEditingController(text: isEdit ? siswiData['alamat'] : '');
    final namaAyahCtrl = TextEditingController(text: isEdit ? siswiData['namaAyah'] : '');
    final namaIbuCtrl = TextEditingController(text: isEdit ? siswiData['namaIbu'] : '');
    final bagianCtrl = TextEditingController(text: isEdit ? siswiData['bagian'] : '');
    final tahunMasukCtrl = TextEditingController(text: isEdit ? siswiData['tahunMasuk'] : '');
    final tahunKeluarCtrl = TextEditingController(text: isEdit ? siswiData['tahunKeluar'] : '');
    
    String selectedKelas = isEdit ? (siswiData['kelasId'] ?? kelasList.first['id']) : kelasList.first['id'];
    String selectedStatus = isEdit ? (siswiData['status'] ?? 'Aktif') : 'Aktif';

    // Parse existing custom fields if any
    Map<String, dynamic> customFieldsData = {};
    if (isEdit && siswiData['customFields'] != null) {
      try {
        if (siswiData['customFields'] is String) {
          customFieldsData = json.decode(siswiData['customFields']);
        } else {
          customFieldsData = Map<String, dynamic>.from(siswiData['customFields']);
        }
      } catch (e) {
        // ignore
      }
    }
    
    // Convert to list of controllers for dynamic editing
    List<Map<String, TextEditingController>> customFieldsControllers = customFieldsData.entries.map((e) {
      return {
        'key': TextEditingController(text: e.key),
        'value': TextEditingController(text: e.value.toString()),
      };
    }).toList();

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
                  constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isEdit ? 'Edit Siswi' : 'Tambah Siswi', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NeuTextField(label: 'Nomor Stambuk', hint: 'Contoh: 1001', controller: nisCtrl),
                              const SizedBox(height: 16),
                              NeuTextField(label: 'Nama Lengkap', hint: 'Contoh: Aisyah', controller: nameCtrl),
                              const SizedBox(height: 16),
                              const Text('Kelas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
                                    value: selectedKelas,
                                    isExpanded: true,
                                    items: kelasList.map<DropdownMenuItem<String>>((k) {
                                      return DropdownMenuItem(value: k['id'], child: Text(k['name']));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setStateBuilder(() => selectedKelas = val);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: NeuTextField(label: 'Kamar', hint: 'Cth: A01', controller: kamarCtrl)),
                                  const SizedBox(width: 16),
                                  Expanded(child: NeuTextField(label: 'Bagian', hint: 'Cth: A', controller: bagianCtrl)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: NeuTextField(label: 'Tempat Lahir', hint: 'Cth: Jakarta', controller: tempatLahirCtrl)),
                                  const SizedBox(width: 16),
                                  Expanded(child: NeuTextField(label: 'Tanggal Lahir', hint: 'YYYY-MM-DD', controller: tanggalLahirCtrl)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              NeuTextField(label: 'Alamat', hint: 'Cth: Jl. Merdeka No.1', controller: alamatCtrl),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: NeuTextField(label: 'Nama Ayah', hint: 'Nama Ayah', controller: namaAyahCtrl)),
                                  const SizedBox(width: 16),
                                  Expanded(child: NeuTextField(label: 'Nama Ibu', hint: 'Nama Ibu', controller: namaIbuCtrl)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
                                    value: selectedStatus,
                                    isExpanded: true,
                                    items: ['Aktif', 'Cuti', 'Boyong'].map<DropdownMenuItem<String>>((s) {
                                      return DropdownMenuItem(value: s, child: Text(s));
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) setStateBuilder(() => selectedStatus = val);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: NeuTextField(label: 'Tahun Masuk', hint: 'Cth: 2023', controller: tahunMasukCtrl)),
                                  if (selectedStatus != 'Aktif') ...[
                                    const SizedBox(width: 16),
                                    Expanded(child: NeuTextField(label: 'Tahun Keluar', hint: 'Cth: 2026', controller: tahunKeluarCtrl)),
                                  ]
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Informasi Tambahan (Opsional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.blue),
                                    onPressed: () {
                                      setStateBuilder(() {
                                        customFieldsControllers.add({
                                          'key': TextEditingController(),
                                          'value': TextEditingController(),
                                        });
                                      });
                                    },
                                    tooltip: 'Tambah Kolom',
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...customFieldsControllers.asMap().entries.map((entry) {
                                int idx = entry.key;
                                var cols = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: NeuTextField(label: 'Nama Kolom', hint: 'Cth: Hobi', controller: cols['key']!),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 3,
                                        child: NeuTextField(label: 'Isi Kolom', hint: 'Cth: Membaca', controller: cols['value']!),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                        onPressed: () {
                                          setStateBuilder(() {
                                            customFieldsControllers.removeAt(idx);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
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
                            onPressed: () async {
                              // Collect custom fields
                              Map<String, String> finalCustomFields = {};
                              for (var cols in customFieldsControllers) {
                                String k = cols['key']!.text.trim();
                                String v = cols['value']!.text.trim();
                                if (k.isNotEmpty) finalCustomFields[k] = v;
                              }

                              final body = {
                                'nis': nisCtrl.text,
                                'name': nameCtrl.text,
                                'kelasId': selectedKelas,
                                'kamar': kamarCtrl.text,
                                'tempatLahir': tempatLahirCtrl.text,
                                'tanggalLahir': tanggalLahirCtrl.text,
                                'alamat': alamatCtrl.text,
                                'namaAyah': namaAyahCtrl.text,
                                'namaIbu': namaIbuCtrl.text,
                                'bagian': bagianCtrl.text,
                                'tahunMasuk': tahunMasukCtrl.text,
                                'status': selectedStatus,
                                'tahunKeluar': selectedStatus == 'Aktif' ? null : tahunKeluarCtrl.text,
                                'customFields': finalCustomFields,
                              };
                              
                              final url = isEdit ? '$kBaseUrl/siswi/${siswiData['id']}' : '$kBaseUrl/siswi';
                              final req = isEdit 
                                  ? http.put(Uri.parse(url), body: json.encode(body), headers: {'Content-Type': 'application/json'})
                                  : http.post(Uri.parse(url), body: json.encode(body), headers: {'Content-Type': 'application/json'});
                              
                              await req;
                              if (!context.mounted) return;
                              Navigator.pop(ctx);
                              ref.invalidate(siswiProvider);
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

  void _deleteSiswi(String id) async {
    await http.delete(Uri.parse('$kBaseUrl/siswi/$id'));
    ref.invalidate(siswiProvider);
  }

  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      var fileBytes = result.files.first.bytes;
      var fileName = result.files.first.name;

      if (fileBytes == null) return;

      var request = http.MultipartRequest('POST', Uri.parse('$kBaseUrl/siswi/import'));
      request.files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mengimport data...')));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        ref.invalidate(siswiProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil mengimport data siswi!')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal import data.')));
        }
      }
    }
  }

  void _showImportModal() {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_rounded, color: AppColors.primary, size: 64),
                  const SizedBox(height: 16),
                  const Text('Import Data Siswi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                  const SizedBox(height: 8),
                  const Text('Gunakan template Excel yang disediakan untuk mengunggah data secara massal.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                  const SizedBox(height: 32),
                  NeuButton(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: () {
                      launchUrl(Uri.parse('$kBaseUrl/siswi/template'));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download_rounded, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text('Unduh Template Excel', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  NeuButton(
                    color: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await _uploadFile();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Unggah File & Import', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  String _getKelasName(List<dynamic>? kelasList, String? id) {
    if (id == null) return '-';
    if (kelasList == null) return id;
    final found = kelasList.where((k) => k['id'] == id).toList();
    return found.isNotEmpty ? (found.first['name'] as String? ?? id) : id;
  }

  @override
  Widget build(BuildContext context) {
    final siswiState = ref.watch(siswiProvider);
    final kelasState = ref.watch(kelasProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data Siswi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                SizedBox(height: 4),
                Text('Kelola pendaftaran santri dan penempatan kelas.', style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight)),
              ],
            ),
            Row(
              children: [
                NeuButton(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  onPressed: _showImportModal,
                  child: const Row(
                    children: [
                      Icon(Icons.download_rounded, color: AppColors.primary, size: 18),
                      SizedBox(width: 6),
                      Text('Import', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                NeuButton(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  onPressed: () {
                    launchUrl(Uri.parse('$kBaseUrl/siswi/export'));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.upload_rounded, color: Colors.green, size: 18),
                      SizedBox(width: 6),
                      Text('Export', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                NeuButton(
                  color: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  onPressed: () {
                    _showFormDialog(kelasList: kelasState.value);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Tambah Siswi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: NeuContainer(
            padding: EdgeInsets.zero,
            child: siswiState.when(
              data: (siswiList) {
                if (siswiList.isEmpty) {
                  return const Center(child: Text('Belum ada data siswi.', style: TextStyle(color: AppColors.textHintLight)));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: siswiList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderLight),
                  itemBuilder: (context, index) {
                    final siswi = siswiList[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withValues(alpha: 0.2),
                        child: const Icon(Icons.person_rounded, color: Colors.blue, size: 20),
                      ),
                      title: Row(
                        children: [
                          Text(siswi['name'] as String? ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryDark)),
                          const SizedBox(width: 8),
                          if (siswi['status'] != 'Aktif' && siswi['status'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                              child: Text(siswi['status'], style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600)),
                            ),
                        ],
                      ),
                      subtitle: Text(
                        'No. Stambuk: ${siswi['nis'] ?? '-'} • Kamar: ${siswi['kamar'] ?? '-'} • Kelas: ${_getKelasName(kelasState.value, siswi['kelasId'])}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 20),
                            onPressed: () => _showFormDialog(
                              siswiData: siswi,
                              kelasList: kelasState.value,
                            ),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                            onPressed: () => _deleteSiswi(siswi['id']),
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
