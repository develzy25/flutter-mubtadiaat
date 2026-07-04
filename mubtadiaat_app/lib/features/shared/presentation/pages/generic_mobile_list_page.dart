import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../core/services/api_service.dart';

class GenericMobileListPage extends ConsumerWidget {
  final String title;
  final String endpoint;

  const GenericMobileListPage({
    super.key,
    required this.title,
    required this.endpoint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(genericListProvider(endpoint));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 15)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        toolbarHeight: 48,
      ),
      body: dataAsync.when(
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

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map<String, dynamic>;
              final keys = item.keys.toList();

              String cardTitle = 'Item ${index + 1}';
              String cardSubtitle = '';
              String cardTrailing = '';

              if (keys.isNotEmpty) cardTitle = item[keys[0]].toString();
              if (keys.length > 1) cardSubtitle = item[keys[1]].toString();
              if (keys.length > 2) cardTrailing = item[keys[2]].toString();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NeuContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  borderRadius: 12,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.api_rounded, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cardTitle, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark, fontSize: 13)),
                            if (cardSubtitle.isNotEmpty)
                              Text(cardSubtitle, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
                          ],
                        ),
                      ),
                      if (cardTrailing.isNotEmpty)
                        Text(cardTrailing, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form Tambah $title'), duration: const Duration(seconds: 1)));
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
      ),
    );
  }
}
