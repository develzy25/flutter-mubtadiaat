import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../shared/widgets/neu_button.dart';
import '../../../../shared/widgets/neu_text_field.dart';
import '../../../../core/services/api_service.dart';

// --- Provider ---
final penggunaProvider = FutureProvider.family<List<dynamic>, String?>((ref, roleFilter) async {
  final url = roleFilter != null ? '$kBaseUrl/users?role=$roleFilter' : '$kBaseUrl/users';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Gagal memuat pengguna');
  }
});

class PenggunaSistemPage extends ConsumerStatefulWidget {
  final String? roleFilter;
  const PenggunaSistemPage({super.key, this.roleFilter});

  @override
  ConsumerState<PenggunaSistemPage> createState() => _PenggunaSistemPageState();
}

class _PenggunaSistemPageState extends ConsumerState<PenggunaSistemPage> {
  
  void _showFormDialog({Map<String, dynamic>? user}) {
    final isEdit = user != null;
    final usernameCtrl = TextEditingController(text: isEdit ? user['username'] : '');
    final nameCtrl = TextEditingController(text: isEdit ? user['fullName'] : '');
    final passCtrl = TextEditingController();
    String selectedRole = isEdit ? user['role'] : 'mustahiq';

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
                      Text(isEdit ? 'Edit Pengguna' : 'Tambah Pengguna', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                      const SizedBox(height: 20),
                      NeuTextField(label: 'Nama Lengkap', hint: 'Masukkan nama', controller: nameCtrl),
                      const SizedBox(height: 16),
                      NeuTextField(label: 'Username', hint: 'Masukkan username', controller: usernameCtrl),
                      const SizedBox(height: 16),
                      if (!isEdit) ...[
                        NeuTextField(label: 'Password', hint: 'Masukkan password', controller: passCtrl, obscureText: true),
                        const SizedBox(height: 16),
                      ],
                      const Text('Role Akses', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
                            value: selectedRole,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: 'admin', child: Text('Admin Kantor')),
                              DropdownMenuItem(value: 'mustahiq', child: Text('Mustahiq (Guru)')),
                              DropdownMenuItem(value: 'mufattish', child: Text('Mufattish')),
                              DropdownMenuItem(value: 'mundzir', child: Text('Mundzir')),
                            ],
                            onChanged: (val) {
                              if (val != null) setStateBuilder(() => selectedRole = val);
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
                                'username': usernameCtrl.text,
                                'fullName': nameCtrl.text,
                                'role': selectedRole,
                                if (!isEdit) 'passwordHash': passCtrl.text,
                              };
                              
                              final url = isEdit 
                                  ? '$kBaseUrl/users/${user['id']}' 
                                  : '$kBaseUrl/users';
                              
                              final req = isEdit 
                                  ? http.put(Uri.parse(url), body: json.encode(body))
                                  : http.post(Uri.parse(url), body: json.encode(body));
                              
                              await req;
                              if (!context.mounted) return;
                              Navigator.pop(ctx);
                              ref.invalidate(penggunaProvider);
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

  void _deleteUser(String id) async {
    await http.delete(Uri.parse('$kBaseUrl/users/$id'));
    ref.invalidate(penggunaProvider);
  }

  @override
  Widget build(BuildContext context) {
    final penggunaState = ref.watch(penggunaProvider(widget.roleFilter));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pengguna Sistem', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                SizedBox(height: 4),
                Text('Kelola akun login untuk Mustahiq, Mufattish, Mundzir, dan Admin.', style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight)),
              ],
            ),
            NeuButton(
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              onPressed: () => _showFormDialog(),
              child: const Row(
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Tambah Pengguna', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: NeuContainer(
            padding: EdgeInsets.zero,
            child: penggunaState.when(
              data: (users) {
                if (users.isEmpty) {
                  return const Center(child: Text('Belum ada data pengguna.', style: TextStyle(color: AppColors.textHintLight)));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderLight),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                        child: Text(user['fullName'][0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                      title: Text(user['fullName'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryDark)),
                      subtitle: Text('${user['username']} • Role: ${user['role'].toUpperCase()}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 20),
                            onPressed: () => _showFormDialog(user: user),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                            onPressed: () => _deleteUser(user['id']),
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
