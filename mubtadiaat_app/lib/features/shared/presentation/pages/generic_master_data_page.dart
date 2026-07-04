import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../shared/widgets/neu_button.dart';
import '../../../../shared/widgets/neu_text_field.dart';
import '../../../../core/services/api_service.dart';

class GenericMasterDataPage extends ConsumerStatefulWidget {
  final String title;
  final String endpoint;
  final List<String> formFields;

  const GenericMasterDataPage({
    super.key,
    required this.title,
    required this.endpoint,
    this.formFields = const [], // Jika kosong, form tidak bisa tambah data
  });

  @override
  ConsumerState<GenericMasterDataPage> createState() => _GenericMasterDataPageState();
}

class _GenericMasterDataPageState extends ConsumerState<GenericMasterDataPage> {
  void _showFormModal(BuildContext context, {Map<String, dynamic>? initialData}) {
    if (widget.formFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konfigurasi field form belum tersedia.')));
      return;
    }

    final isEdit = initialData != null;
    final controllers = <String, TextEditingController>{};
    for (var field in widget.formFields) {
      controllers[field] = TextEditingController(text: initialData?[field]?.toString() ?? '');
    }

    showDialog(
      context: context,
      builder: (ctx) {
        bool isLoading = false;
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
                      Text(isEdit ? 'Edit ${widget.title}' : 'Tambah ${widget.title}', 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                      const SizedBox(height: 20),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: widget.formFields.map((field) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: NeuTextField(
                                  label: field.toUpperCase().replaceAll('_', ' '),
                                  hint: 'Masukkan $field',
                                  controller: controllers[field]!,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isLoading ? null : () => Navigator.pop(ctx),
                            child: const Text('Batal', style: TextStyle(color: AppColors.textHintLight)),
                          ),
                          const SizedBox(width: 12),
                          NeuButton(
                            color: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            borderRadius: 12,
                            onPressed: () {
                              if (isLoading) return;
                              () async {
                                setStateBuilder(() => isLoading = true);
                                final payload = <String, dynamic>{};
                                for (var field in widget.formFields) {
                                  payload[field] = controllers[field]!.text;
                                }
                                
                                try {
                                  final api = ref.read(apiServiceProvider);
                                  if (isEdit) {
                                    await api.put('${widget.endpoint}/${initialData['id']}', data: payload);
                                  } else {
                                    await api.post(widget.endpoint, data: payload);
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(ctx);
                                    ref.invalidate(genericListProvider(widget.endpoint));
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.title} berhasil disimpan.')));
                                  }
                                } catch (e) {
                                  setStateBuilder(() => isLoading = false);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                  }
                                }
                              }();
                            },
                            child: isLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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
      },
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data?'),
        content: const Text('Data yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final api = ref.read(apiServiceProvider);
                await api.delete('${widget.endpoint}/$id');
                ref.invalidate(genericListProvider(widget.endpoint));
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data dihapus.')));
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            }, 
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(genericListProvider(widget.endpoint));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                Text('Endpoint: ${widget.endpoint}', style: const TextStyle(color: AppColors.textHintLight, fontSize: 11)),
              ],
            ),
            NeuButton(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              borderRadius: 10,
              onPressed: () => _showFormModal(context),
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

        // Data Table
        Expanded(
          child: NeuContainer(
            padding: const EdgeInsets.all(14),
            borderRadius: 14,
            child: dataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 36, color: Colors.red),
                    const SizedBox(height: 10),
                    Text('Gagal memuat data.\n$err', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_rounded, size: 40, color: AppColors.textHintLight),
                        SizedBox(height: 8),
                        Text('Belum ada data.', style: TextStyle(color: AppColors.textHintLight, fontSize: 13)),
                      ],
                    ),
                  );
                }

                final firstItem = items.first as Map<String, dynamic>;
                final columns = firstItem.keys.toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      horizontalMargin: 0,
                      columnSpacing: 20,
                      dataRowMinHeight: 34,
                      dataRowMaxHeight: 38,
                      headingRowHeight: 34,
                      columns: [
                        ...columns.map((col) => DataColumn(
                          label: Text(col.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                        )),
                        const DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11))),
                      ],
                      rows: items.map((item) {
                        final map = item as Map<String, dynamic>;
                        return DataRow(
                          cells: [
                            ...columns.map((col) => DataCell(
                              Text(map[col].toString(), style: const TextStyle(fontSize: 12)),
                            )),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, size: 16, color: AppColors.primary),
                                    onPressed: () => _showFormModal(context, initialData: map),
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_rounded, size: 16, color: Colors.redAccent),
                                    onPressed: () => _confirmDelete(context, map['id'].toString()),
                                    tooltip: 'Hapus',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
