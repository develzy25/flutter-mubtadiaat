import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/input_nilai_controller.dart';
import '../../domain/rules/perhitungan_nilai_rules.dart';
import '../../domain/entities/nilai_mapel.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/neu_container.dart';

class InputNilaiPage extends ConsumerWidget {
  final String kelasId;
  
  const InputNilaiPage({super.key, required this.kelasId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inputNilaiControllerProvider(kelasId));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      appBar: AppBar(
        title: const Text('Input Nilai Kuartal', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 15)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryDark),
        toolbarHeight: 48,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text('Error: ${state.error}'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: state.nilaiList.length,
                  itemBuilder: (context, index) {
                    final nilai = state.nilaiList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: MapelRowWidget(kelasId: kelasId, mapel: nilai),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menyimpan nilai...'), duration: Duration(seconds: 1)),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.save_rounded, size: 20),
      ),
    );
  }
}

class MapelRowWidget extends ConsumerStatefulWidget {
  final String kelasId;
  final NilaiMapel mapel;

  const MapelRowWidget({super.key, required this.kelasId, required this.mapel});

  @override
  ConsumerState<MapelRowWidget> createState() => _MapelRowWidgetState();
}

class _MapelRowWidgetState extends ConsumerState<MapelRowWidget> {
  late TextEditingController _tamrinCtrl;
  late TextEditingController _ujianCtrl;
  late TextEditingController _khosCtrl;

  @override
  void initState() {
    super.initState();
    _tamrinCtrl = TextEditingController(text: widget.mapel.nilaiTamrin?.toString() ?? '');
    _ujianCtrl = TextEditingController(text: widget.mapel.nilaiUjian?.toString() ?? '');
    _khosCtrl = TextEditingController(text: widget.mapel.nilaiKhos?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant MapelRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Only update Khos controller if it was auto-calculated and changed
    final state = ref.read(inputNilaiControllerProvider(widget.kelasId));
    final isManual = state.overriddenKhosMapelIds.contains(widget.mapel.mapelId);
    
    if (!isManual && widget.mapel.nilaiKhos != oldWidget.mapel.nilaiKhos) {
      _khosCtrl.text = widget.mapel.nilaiKhos?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _tamrinCtrl.dispose();
    _ujianCtrl.dispose();
    _khosCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      borderRadius: 12,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.mapel.mapelName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Tamrin',
                  controller: _tamrinCtrl,
                  mapelName: widget.mapel.mapelName,
                  onChanged: (val) {
                    final numVal = double.tryParse(val);
                    ref.read(inputNilaiControllerProvider(widget.kelasId).notifier).updateTamrin(widget.mapel.mapelId, numVal);
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildInputField(
                  label: 'Ujian',
                  controller: _ujianCtrl,
                  mapelName: widget.mapel.mapelName,
                  onChanged: (val) {
                    final numVal = double.tryParse(val);
                    ref.read(inputNilaiControllerProvider(widget.kelasId).notifier).updateUjian(widget.mapel.mapelId, numVal);
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildInputField(
                  label: 'Khos (Auto/Edit)',
                  controller: _khosCtrl,
                  mapelName: widget.mapel.mapelName,
                  isHighlighted: true,
                  onChanged: (val) {
                    final numVal = int.tryParse(val);
                    ref.read(inputNilaiControllerProvider(widget.kelasId).notifier).updateKhosManual(widget.mapel.mapelId, numVal);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String mapelName,
    required Function(String) onChanged,
    bool isHighlighted = false,
  }) {
    // Determine validation error dynamically
    final doubleVal = double.tryParse(controller.text);
    final errorText = PerhitunganNilaiRules.validasiInputNilai(doubleVal, mapelName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4.0),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (val) {
            onChanged(val);
            setState(() {}); // trigger rebuild to show/hide error
          },
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isHighlighted ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceLight,
            errorText: errorText,
            errorMaxLines: 2,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            border: OutlineInputBorder(
              borderRadius: AppRadius.sm,
              borderSide: BorderSide(color: isHighlighted ? AppColors.primary : AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.sm,
              borderSide: BorderSide(color: isHighlighted ? AppColors.primary : AppColors.borderLight),
            ),
          ),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isHighlighted ? AppColors.primary : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
