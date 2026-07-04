import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neu_container.dart';
import '../../../../shared/widgets/neu_button.dart';
import '../../../../core/providers/role_provider.dart';
import '../../../shared/presentation/pages/generic_master_data_page.dart';
import '../../../pengguna/presentation/pages/pengguna_sistem_page.dart';
import '../../../master_data/presentation/pages/data_kelas_page.dart';
import '../../../master_data/presentation/pages/data_siswi_page.dart';
import '../../../akademik/presentation/pages/pembagian_guru_page.dart';
import '../../../akademik/presentation/pages/mutasi_page.dart';
import '../../shared/services/updater_service.dart';
import '../../shared/widgets/update_dialog.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  String _selectedMenuTitle = 'Dashboard';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    final updater = UpdaterService();
    final release = await updater.checkForUpdate();
    if (release != null && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UpdateDialog(release: release),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 1000;
    final isCollapsed = width < 800;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF0F3F8),
      drawer: isCollapsed ? _buildDrawer() : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCollapsed) _buildSidebar(isCompact),
          Expanded(child: _buildMainContent(isCollapsed)),
        ],
      ),
    );
  }

  // ── Drawer (for < 800px) ──
  Widget _buildDrawer() {
    final role = ref.watch(roleProvider);
    final menus = _getMenusForRole(role);

    return Drawer(
      backgroundColor: const Color(0xFFF0F3F8),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildSidebarLogo(false),
            const SizedBox(height: 16),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  return _buildMenuNode(menus[index], false);
                },
              ),
            ),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  // ── Sidebar (for >= 800px) ──
  Widget _buildSidebar(bool isCompact) {
    final role = ref.watch(roleProvider);
    final menus = _getMenusForRole(role);
    final sidebarWidth = isCompact ? 64.0 : 220.0;

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(3, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildSidebarLogo(isCompact),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: isCompact ? 6 : 10, vertical: 4),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                return _buildMenuNode(menus[index], isCompact);
              },
            ),
          ),
          if (!isCompact) _buildLogoutButton(),
          if (isCompact)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                tooltip: 'Keluar',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarLogo(bool isCompact) {
    if (isCompact) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset('assets/images/logo.png', width: 36, height: 36, fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/logo.png', width: 32, height: 32, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, color: AppColors.primary, size: 24),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text("e-Mubtadi'at", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primaryDark)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuNode(_MenuDef menu, bool isCompact) {
    if (menu.subMenus.isEmpty) {
      return _buildMenuItem(menu.title, menu.icon, menu.title, isCompact);
    }
    
    // Sub-menus
    bool hasSelectedChild = menu.subMenus.any((sub) => sub.title == _selectedMenuTitle);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: isCompact 
          ? PopupMenuButton<String>(
              offset: const Offset(60, 0),
              icon: Icon(menu.icon, color: hasSelectedChild ? AppColors.primary : AppColors.textSecondaryLight),
              onSelected: (val) {
                setState(() => _selectedMenuTitle = val);
              },
              itemBuilder: (context) => menu.subMenus.map((sub) => 
                PopupMenuItem(
                  value: sub.title,
                  child: Row(
                    children: [
                      Icon(sub.icon, size: 18, color: sub.title == _selectedMenuTitle ? AppColors.primary : AppColors.textSecondaryLight),
                      const SizedBox(width: 8),
                      Text(sub.title, style: TextStyle(color: sub.title == _selectedMenuTitle ? AppColors.primary : AppColors.primaryDark, fontSize: 13, fontWeight: sub.title == _selectedMenuTitle ? FontWeight.bold : FontWeight.normal)),
                    ],
                  ),
                )
              ).toList(),
            )
          : ExpansionTile(
              initiallyExpanded: hasSelectedChild,
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              childrenPadding: const EdgeInsets.only(left: 16),
              leading: Icon(menu.icon, color: hasSelectedChild ? AppColors.primary : AppColors.textSecondaryLight, size: 18),
              title: Text(
                menu.title,
                style: TextStyle(
                  color: hasSelectedChild ? AppColors.primary : AppColors.textSecondaryLight,
                  fontWeight: hasSelectedChild ? FontWeight.bold : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              children: menu.subMenus.map((sub) => _buildMenuItem(sub.title, sub.icon, sub.title, false, isSubMenu: true)).toList(),
            ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, String fullTitle, bool isCompact, {bool isSubMenu = false}) {
    final isSelected = _selectedMenuTitle == title;
    return Padding(
      padding: EdgeInsets.only(bottom: isSubMenu ? 2 : 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            setState(() => _selectedMenuTitle = title);
            if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
              Navigator.of(context).pop();
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: isCompact ? 0 : 12, vertical: isSubMenu ? 8 : 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: isSelected ? [
                BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
              ] : null,
            ),
            child: isCompact
                ? Center(
                    child: Tooltip(
                      message: title,
                      child: Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondaryLight, size: 20),
                    ),
                  )
                : Row(
                    children: [
                      Icon(icon, color: isSelected ? Colors.white : (isSubMenu ? AppColors.textHintLight : AppColors.textSecondaryLight), size: isSubMenu ? 16 : 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondaryLight,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: isSubMenu ? 12 : 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: NeuButton(
        padding: const EdgeInsets.symmetric(vertical: 10),
        borderRadius: 10,
        color: Colors.redAccent.withValues(alpha: 0.08),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red, size: 18),
            SizedBox(width: 6),
            Text('Keluar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // ── Main Content Area ──
  Widget _buildMainContent(bool isCollapsed) {
    final role = ref.watch(roleProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopbar(role, isCollapsed),
            const SizedBox(height: 20),
            Expanded(
              child: _selectedMenuTitle == 'Dashboard'
                  ? _buildDashboardWidgets()
                  : _selectedMenuTitle == 'Pengguna Sistem'
                      ? const PenggunaSistemPage()
                  : _selectedMenuTitle == 'Mustahiq (Guru)'
                      ? const PenggunaSistemPage(roleFilter: 'mustahiq')
                  : _selectedMenuTitle == 'Mufattish'
                      ? const PenggunaSistemPage(roleFilter: 'mufattish')
                  : _selectedMenuTitle == 'Mundzir'
                      ? const PenggunaSistemPage(roleFilter: 'mundzir')
                  : _selectedMenuTitle == 'Kelas'
                      ? const DataKelasPage()
                  : _selectedMenuTitle == 'Data Siswi'
                      ? const DataSiswiPage()
                  : _selectedMenuTitle == 'Data Kamar'
                      ? const GenericMasterDataPage(title: 'Data Kamar', endpoint: '/kamar', formFields: ['name'])
                  : _selectedMenuTitle == 'Data Bagian'
                      ? const GenericMasterDataPage(title: 'Data Bagian', endpoint: '/bagian', formFields: ['name'])
                  : _selectedMenuTitle == 'Data Ekstrakurikuler'
                      ? const GenericMasterDataPage(title: 'Data Ekstrakurikuler', endpoint: '/ekstrakurikuler', formFields: ['name'])
                  : _selectedMenuTitle == 'Tahun Ajaran'
                      ? const GenericMasterDataPage(title: 'Tahun Ajaran', endpoint: '/tahun-ajaran', formFields: ['name'])
                  : _selectedMenuTitle == 'Semester'
                      ? const GenericMasterDataPage(title: 'Semester', endpoint: '/semester', formFields: ['name', 'tahunAjaranId'])
                  : _selectedMenuTitle == 'Jenjang'
                      ? const GenericMasterDataPage(title: 'Jenjang', endpoint: '/jenjang', formFields: ['name'])
                  : _selectedMenuTitle == 'Mapel'
                      ? const GenericMasterDataPage(title: 'Mapel', endpoint: '/mapel', formFields: ['name', 'jenjangId'])
                  : _selectedMenuTitle == 'Jadwal'
                      ? const GenericMasterDataPage(title: 'Jadwal', endpoint: '/jadwal', formFields: ['hari', 'waktu', 'mapel', 'kelas'])
                  : _selectedMenuTitle == 'Tamrin'
                      ? const GenericMasterDataPage(title: 'Tamrin', endpoint: '/tamrin', formFields: ['name', 'tanggal'])
                  : _selectedMenuTitle == 'Hak Akses'
                      ? const GenericMasterDataPage(title: 'Hak Akses', endpoint: '/hak-akses', formFields: ['roleName', 'permissions'])
                  : _selectedMenuTitle == 'Validasi Nilai'
                      ? const GenericMasterDataPage(title: 'Validasi Nilai', endpoint: '/validasi-nilai', formFields: ['kelas', 'status'])
                  : _selectedMenuTitle == 'Kunci Nilai'
                      ? const GenericMasterDataPage(title: 'Kunci Nilai', endpoint: '/kunci-nilai', formFields: ['semester'])
                  : _selectedMenuTitle == 'e-Rapor'
                      ? const GenericMasterDataPage(title: 'e-Rapor', endpoint: '/e-rapor', formFields: ['siswa', 'semester', 'link'])
                  : _selectedMenuTitle == 'e-Sertifikat'
                      ? const GenericMasterDataPage(title: 'e-Sertifikat', endpoint: '/e-sertifikat', formFields: ['siswa', 'kegiatan', 'link'])
                  : _selectedMenuTitle == 'Pembagian Guru'
                      ? const PembagianGuruPage()
                  : _selectedMenuTitle == 'Mutasi'
                      ? const MutasiPage()
                  : GenericMasterDataPage(
                      title: _selectedMenuTitle,
                      endpoint: '/${_selectedMenuTitle.toLowerCase().replaceAll(' ', '-')}',
                      formFields: const ['name'],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopbar(AppRole role, bool isCollapsed) {
    return Row(
      children: [
        if (isCollapsed)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: NeuButton(
              padding: const EdgeInsets.all(8),
              borderRadius: 10,
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              child: const Icon(Icons.menu_rounded, color: AppColors.primary, size: 20),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
              const Text('Panel Administrasi', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
            ],
          ),
        ),
        // Demo Role Switcher
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.premiumGold.withValues(alpha: 0.4)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AppRole>(
              value: role,
              icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.premiumGold, size: 16),
              style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 12),
              isDense: true,
              onChanged: (AppRole? v) {
                if (v != null) {
                  ref.read(roleProvider.notifier).setRole(v);
                  setState(() => _selectedMenuTitle = 'Dashboard');
                }
              },
              items: AppRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.name, style: const TextStyle(fontSize: 12)))).toList(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        NeuButton(
          padding: const EdgeInsets.all(8),
          borderRadius: 10,
          onPressed: () {},
          child: const Icon(Icons.notifications_none_rounded, color: AppColors.primary, size: 18),
        ),
      ],
    );
  }

  // ── Dashboard Widgets ──
  Widget _buildDashboardWidgets() {
    final siswiState = ref.watch(siswiProvider);
    final usersState = ref.watch(penggunaProvider(null));

    // Calculate dynamic stats
    int totalSiswi = 0;
    int totalUsers = 0;
    
    siswiState.whenData((list) => totalSiswi = list.length);
    usersState.whenData((list) => totalUsers = list.length);

    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 700;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stat Cards
              narrow
                  ? Column(
                      children: [
                        Row(children: [
                          _buildStatCard('Jumlah Siswi', '$totalSiswi', Icons.people_alt_rounded, AppColors.primary),
                          const SizedBox(width: 12),
                          _buildStatCard('Pengurus', '$totalUsers', Icons.admin_panel_settings_rounded, AppColors.secondary),
                        ]),
                        const SizedBox(height: 12),
                        Row(children: [
                          _buildStatCard('Hadir', '$totalSiswi', Icons.check_circle_rounded, AppColors.success),
                          const SizedBox(width: 12),
                          _buildStatCard('Sakit/Izin', '0', Icons.warning_rounded, AppColors.warning),
                        ]),
                      ],
                    )
                  : Row(
                      children: [
                        _buildStatCard('Jumlah Siswi', '$totalSiswi', Icons.people_alt_rounded, AppColors.primary),
                        const SizedBox(width: 12),
                        _buildStatCard('Pengurus', '$totalUsers', Icons.admin_panel_settings_rounded, AppColors.secondary),
                        const SizedBox(width: 12),
                        _buildStatCard('Hadir', '$totalSiswi', Icons.check_circle_rounded, AppColors.success),
                        const SizedBox(width: 12),
                        _buildStatCard('Sakit/Izin', '0', Icons.warning_rounded, AppColors.warning),
                      ],
                    ),
              const SizedBox(height: 20),

              // Charts + Pie (side-by-side on wide, stacked on narrow)
              narrow
                  ? Column(children: [
                      _buildBarChartCard(),
                      const SizedBox(height: 16),
                      _buildPieChartCard(),
                      const SizedBox(height: 16),
                      _buildRecentActivityCard(),
                    ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(children: [
                            _buildBarChartCard(),
                            const SizedBox(height: 16),
                            _buildRecentActivityCard(),
                          ]),
                        ),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: _buildPieChartCard()),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBarChartCard() {
    return NeuContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rata-rata Nilai per Jenjang', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(getTooltipColor: (_) => AppColors.primaryDark),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600, fontSize: 10);
                        final labels = ["I'dad", "Ibtida'", "Tsanaw", "Aliyah"];
                        final idx = value.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(idx < labels.length ? labels[idx] : '', style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24, interval: 2)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true, drawVerticalLine: false, horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) => FlLine(color: AppColors.primary.withValues(alpha: 0.07), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _bar(0, 7.5, AppColors.primary),
                  _bar(1, 8.2, AppColors.primary),
                  _bar(2, 8.8, AppColors.primary),
                  _bar(3, 9.1, AppColors.primaryLight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y, color: color, width: 16, borderRadius: BorderRadius.circular(4)),
    ]);
  }

  Widget _buildPieChartCard() {
    final siswiState = ref.watch(siswiProvider);
    final kelasState = ref.watch(kelasProvider);
    final jenjangState = ref.watch(jenjangProvider);

    int idad = 0;
    int ibt = 0;
    int tsan = 0;
    int aliy = 0;
    int total = 1;

    siswiState.whenData((siswiList) {
      if (siswiList.isNotEmpty) total = siswiList.length;
      kelasState.whenData((kelasList) {
        jenjangState.whenData((jenjangList) {
          for (var s in siswiList) {
            final k = kelasList.firstWhere((x) => x['id'] == s['kelasId'], orElse: () => null);
            if (k != null) {
              final j = jenjangList.firstWhere((x) => x['id'] == k['jenjangId'], orElse: () => null);
              if (j != null) {
                final jName = j['name'].toString().toLowerCase();
                if (jName.contains('idadi')) {
                  idad++;
                } else if (jName.contains('ibtida')) {
                  ibt++;
                } else if (jName.contains('tsana')) {
                  tsan++;
                } else if (jName.contains('aliya')) {
                  aliy++;
                }
              }
            }
          }
        });
      });
    });

    return NeuContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Komposisi Santri', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 30,
                startDegreeOffset: -90,
                sections: [
                  if (ibt > 0) PieChartSectionData(color: AppColors.primary, value: ibt.toDouble(), title: '${(ibt/total*100).round()}%', radius: 22, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (tsan > 0) PieChartSectionData(color: AppColors.secondary, value: tsan.toDouble(), title: '${(tsan/total*100).round()}%', radius: 20, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (aliy > 0) PieChartSectionData(color: AppColors.premiumGold, value: aliy.toDouble(), title: '${(aliy/total*100).round()}%', radius: 18, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (idad > 0) PieChartSectionData(color: Colors.redAccent, value: idad.toDouble(), title: '${(idad/total*100).round()}%', radius: 15, titleStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                  if (total == 1) PieChartSectionData(color: Colors.grey.shade300, value: 100, title: '', radius: 15),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildPieLegend("Ibtida'iyyah", '$ibt', AppColors.primary),
          _buildPieLegend('Tsanawiyyah', '$tsan', AppColors.secondary),
          _buildPieLegend('Aliyyah', '$aliy', AppColors.premiumGold),
          _buildPieLegend("I'dadiyyah", '$idad', Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildPieLegend(String label, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight))),
          Text(count, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    final siswiState = ref.watch(siswiProvider);
    List<DataRow> recentRows = [];
    siswiState.whenData((list) {
      // get top 5 reversed
      final reversed = list.reversed.take(5).toList();
      recentRows = reversed.map((s) => DataRow(cells: [
        DataCell(Text('Siswa Baru: ${s['name']}', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
        const DataCell(Text('Data Siswi', style: TextStyle(fontSize: 12))),
        const DataCell(Text('Baru saja', style: TextStyle(fontSize: 12))),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
          child: const Text('Sukses', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
        )),
      ])).toList();
    });

    return NeuContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aktivitas Terbaru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              horizontalMargin: 0,
              columnSpacing: 16,
              dataRowMinHeight: 36,
              dataRowMaxHeight: 40,
              headingRowHeight: 36,
              columns: const [
                DataColumn(label: Text('Aktivitas', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Modul', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Waktu', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
              ],
              rows: recentRows,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: NeuContainer(
        padding: const EdgeInsets.all(14),
        borderRadius: 14,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textHintLight, fontSize: 10, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(color: AppColors.primaryDark, fontSize: 18, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Menu Definitions ──
  List<_MenuDef> _getMenusForRole(AppRole role) {
    switch (role) {
      case AppRole.admin:
        return const [
          _MenuDef('Dashboard', Icons.dashboard_rounded),
          _MenuDef('Pengaturan', Icons.settings_rounded, subMenus: [
            _MenuDef('Pengguna Sistem', Icons.manage_accounts_rounded),
            _MenuDef('Hak Akses', Icons.security_rounded),
          ]),
          _MenuDef('Master Data', Icons.folder_rounded, subMenus: [
            _MenuDef('Data Siswi', Icons.people_alt_rounded),
            _MenuDef('Kelas', Icons.class_rounded),
            _MenuDef('Mustahiq (Guru)', Icons.badge_rounded),
            _MenuDef('Mufattish', Icons.admin_panel_settings_rounded),
            _MenuDef('Mundzir', Icons.supervised_user_circle_rounded),
            _MenuDef('Tahun Ajaran', Icons.calendar_today_rounded),
            _MenuDef('Semester', Icons.view_timeline_rounded),
            _MenuDef('Jenjang', Icons.account_tree_rounded),
            _MenuDef('Mapel', Icons.book_rounded),
            _MenuDef('Jadwal', Icons.schedule_rounded),
            _MenuDef('Tamrin', Icons.assignment_rounded),
          ]),
          _MenuDef('Akademik', Icons.school_rounded, subMenus: [
            _MenuDef('Pembagian Guru', Icons.assignment_ind_rounded),
            _MenuDef('Pembagian Kelas', Icons.group_add_rounded),
            _MenuDef('Mutasi', Icons.swap_horiz_rounded),
          ]),
          _MenuDef('Penilaian', Icons.bar_chart_rounded, subMenus: [
            _MenuDef('Validasi Nilai', Icons.check_circle_rounded),
            _MenuDef('Kunci Nilai', Icons.lock_rounded),
            _MenuDef('e-Rapor', Icons.picture_as_pdf_rounded),
            _MenuDef('e-Sertifikat', Icons.workspace_premium_rounded),
          ]),
        ];
      default:
        return const [_MenuDef('Dashboard', Icons.dashboard_rounded)];
    }
  }
}

class _MenuDef {
  final String title;
  final IconData icon;
  final List<_MenuDef> subMenus;
  const _MenuDef(this.title, this.icon, {this.subMenus = const []});
}
