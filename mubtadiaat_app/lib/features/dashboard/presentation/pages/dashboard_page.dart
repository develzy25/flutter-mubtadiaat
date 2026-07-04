import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../shared/widgets/neu_button.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/providers/role_provider.dart';

/// Provider: daftar kelas yang diampu Mustahiq yang sedang login.
final mustahiqKelasProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  try {
    // Hardcode user ID for demo purposes, since login is not fully implemented
    final response = await api.get('/kelas?mustahiqId=mustahiq-1');
    if (response.data != null) {
      return response.data as List<dynamic>;
    }
    return [];
  } catch (e) {
    return [];
  }
});

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      bottomNavigationBar: _buildBottomNav(context, role),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(ref),
              const SizedBox(height: 16),
              _buildProfileCard(role),
              const SizedBox(height: 16),
              if (role == AppRole.mustahiq) ...[
                _buildMyClassesSection(ref),
                const SizedBox(height: 16),
              ],
              _buildQuickAccessSection(context, role),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    return Row(
      children: [
        // Logo
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('assets/images/logo.png', width: 36, height: 36, fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PP. Hidayatul', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight)),
              Text("Mubtadi'at Lirboyo", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary, height: 1.2)),
            ],
          ),
        ),
        // Demo Role Switcher
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AppRole>(
              value: ref.watch(roleProvider),
              icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primary, size: 16),
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 11),
              isDense: true,
              onChanged: (v) {
                if (v != null) ref.read(roleProvider.notifier).setRole(v);
              },
              items: AppRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.name, style: const TextStyle(fontSize: 11)))).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(AppRole role) {
    return NeuContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 14,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 2),
            ),
            child: const Icon(Icons.person_rounded, size: 24, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role == AppRole.mustahiq ? 'Ust. Ahmad Fauzi' : (role == AppRole.mufattish ? 'K.H. Abdul Mufattish' : 'K.H. Mundzir Akbar'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimaryLight),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                  child: Text(role.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
              ],
            ),
          ),
          NeuButton(
            padding: const EdgeInsets.all(8),
            borderRadius: 12,
            onPressed: () {},
            child: const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondaryLight, size: 18),
          ),
        ],
      ),
    );
  }

  /// Mustahiq: hanya menampilkan kelas yang diampu
  Widget _buildMyClassesSection(WidgetRef ref) {
    final kelasAsync = ref.watch(mustahiqKelasProvider);

    return NeuContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kelas yang Diampu', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              Text('Lihat Semua', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          kelasAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (err, stack) => Text('Error: $err', style: const TextStyle(fontSize: 12, color: Colors.red)),
            data: (kelasList) {
              if (kelasList.isEmpty) {
                return const Text('Belum ada kelas yang diampu.', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight));
              }
              return Column(
                children: kelasList.map((kelas) {
                  final nama = kelas['name']?.toString() ?? '';
                  final mapel = kelas['mapel']?.toString() ?? 'Tatap Muka / Umum';
                  return _buildClassItem(nama, mapel);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassItem(String className, String subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
            child: Text(className, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.primary)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(subject, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textHintLight, size: 18),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection(BuildContext context, AppRole role) {
    List<_QABtn> buttons = [];

    if (role == AppRole.mustahiq) {
      buttons = const [
        _QABtn(Icons.how_to_reg_rounded, Colors.blue, 'Kehadiran\nSiswi', '/penilaian/pilih-kelas/kehadiran'),
        _QABtn(Icons.assignment_rounded, Colors.pink, 'Catatan\nSiswi', '/penilaian/pilih-kelas/catatan'),
        _QABtn(Icons.edit_note_rounded, Colors.green, 'Input\nNilai', '/penilaian/pilih-kelas/input'),
        _QABtn(Icons.quiz_rounded, Colors.orange, 'Tamrin', '/penilaian/pilih-kelas/tamrin'),
      ];
    } else if (role == AppRole.mufattish) {
      buttons = const [
        _QABtn(Icons.fact_check_rounded, Colors.orange, 'Penilaian\nGuru', '/mufattish/penilaian-guru'),
        _QABtn(Icons.assignment_turned_in_rounded, Colors.pink, 'Cek\nTamrin', '/mufattish/cek-tamrin'),
        _QABtn(Icons.verified_rounded, Colors.green, 'Validasi\nNilai', '/mufattish/validasi-nilai'),
        _QABtn(Icons.lock_rounded, Colors.red, 'Kunci\nNilai', '/mufattish/kunci-nilai'),
      ];
    } else if (role == AppRole.mundzir) {
      buttons = const [
        _QABtn(Icons.analytics_rounded, Colors.blue, 'Statistik\nSantri', '/mundzir/statistik'),
        _QABtn(Icons.leaderboard_rounded, Colors.orange, 'Peringkat\nUmum', '/mundzir/peringkat'),
        _QABtn(Icons.account_tree_rounded, Colors.green, 'Rekap\nJenjang', '/mundzir/rekap'),
        _QABtn(Icons.picture_as_pdf_rounded, Colors.purple, 'e-Rapor\nGlobal', '/mundzir/rapor'),
      ];
    }

    return NeuContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Akses Cepat', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons.map((b) => _buildQuickBtn(context, b)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickBtn(BuildContext context, _QABtn btn) {
    return Expanded(
      child: Column(
        children: [
          NeuButton(
            padding: const EdgeInsets.all(10),
            borderRadius: 12,
            onPressed: () {
              try { context.push(btn.route); } catch (_) {}
            },
            child: Icon(btn.icon, color: btn.color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(btn.label, textAlign: TextAlign.center, maxLines: 2,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, AppRole role) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F8),
        boxShadow: [
          const BoxShadow(color: Colors.white, offset: Offset(0, -3), blurRadius: 6),
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), offset: const Offset(0, -3), blurRadius: 6),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home_rounded, 'Beranda', true, '/dashboard'),
              if (role == AppRole.mustahiq) ...[
                _buildNavItem(context, Icons.school_rounded, 'Akademik', false, '/penilaian/pilih-kelas/kelas'),
                _buildNavItem(context, Icons.bar_chart_rounded, 'Nilai', false, '/penilaian/pilih-kelas/input'),
              ] else if (role == AppRole.mufattish) ...[
                _buildNavItem(context, Icons.monitor_rounded, 'Monitoring', false, '/mufattish/monitoring'),
                _buildNavItem(context, Icons.verified_rounded, 'Validasi', false, '/mufattish/validasi'),
              ] else if (role == AppRole.mundzir) ...[
                _buildNavItem(context, Icons.public_rounded, 'Global', false, '/mundzir/global'),
                _buildNavItem(context, Icons.summarize_rounded, 'Laporan', false, '/mundzir/laporan'),
              ],
              _buildNavItem(context, Icons.person_rounded, 'Profil', false, '/dashboard'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive, String route) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          try { context.push(route); } catch (_) {}
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppColors.primary : AppColors.textHintLight, size: 22),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 9, fontWeight: isActive ? FontWeight.w700 : FontWeight.normal, color: isActive ? AppColors.primary : AppColors.textHintLight)),
        ],
      ),
    );
  }
}

class _QABtn {
  final IconData icon;
  final Color color;
  final String label;
  final String route;
  const _QABtn(this.icon, this.color, this.label, this.route);
}
