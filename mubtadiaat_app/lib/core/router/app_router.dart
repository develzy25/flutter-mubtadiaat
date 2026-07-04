import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/role_provider.dart';
import '../../features/penilaian/presentation/pages/input_nilai_page.dart';
import '../../features/penilaian/presentation/pages/finalisasi_kelas_page.dart';
import '../../features/penilaian/presentation/pages/raport_preview_page.dart';
import '../../features/penilaian/presentation/pages/pilih_kelas_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/admin_dashboard_page.dart';
import '../../features/shared/presentation/pages/generic_mobile_list_page.dart';
import '../../main.dart';

class RootDashboardProxy extends ConsumerWidget {
  const RootDashboardProxy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    if (role == AppRole.admin) {
      // SOFTWARE EXE (Kantor)
      return const AdminDashboardPage();
    } else {
      // APK Android (Mustahiq, Mufattish, Mundzir)
      return const DashboardPage();
    }
  }
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const RootDashboardProxy(),
    ),
    GoRoute(
      path: '/mufattish/:action',
      builder: (context, state) => GenericMobileListPage(
        title: 'Mufattish - ${state.pathParameters['action']?.replaceAll('-', ' ').toUpperCase()}',
        endpoint: '/mufattish/${state.pathParameters['action']}',
      ),
    ),
    GoRoute(
      path: '/mundzir/:action',
      builder: (context, state) => GenericMobileListPage(
        title: 'Mundzir - ${state.pathParameters['action']?.replaceAll('-', ' ').toUpperCase()}',
        endpoint: '/mundzir/${state.pathParameters['action']}',
      ),
    ),
    GoRoute(
      path: '/penilaian/pilih-kelas/:action',
      builder: (context, state) {
        final action = state.pathParameters['action'] ?? 'input';
        return PilihKelasPage(action: action);
      },
    ),
    GoRoute(
      path: '/penilaian/input/:kelasId',
      builder: (context, state) {
        final kelasId = state.pathParameters['kelasId'] ?? '';
        return InputNilaiPage(kelasId: kelasId);
      },
    ),
    GoRoute(
      path: '/penilaian/finalisasi/:kelasId',
      builder: (context, state) {
        final kelasId = state.pathParameters['kelasId'] ?? '';
        return FinalisasiKelasPage(kelasId: kelasId);
      },
    ),
    GoRoute(
      path: '/penilaian/raport/:studentId',
      builder: (context, state) {
        final studentId = state.pathParameters['studentId'] ?? '';
        return RaportPreviewPage(studentId: studentId);
      },
    ),
  ],
);
