import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../cubit/mood_cubit.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? _selectedMood;
  double _stressLevel = 3;
  double _energyLevel = 3;
  final TextEditingController _notesController = TextEditingController();
  bool _isDataLoaded = false;

  final List<Map<String, dynamic>> _moods = [
    {'id': 'great', 'label': 'Great', 'icon': '??', 'color': Color(0xFF22C55E)},
    {'id': 'good', 'label': 'Good', 'icon': '??', 'color': Color(0xFF8B5CF6)},
    {'id': 'okay', 'label': 'Okay', 'icon': '??', 'color': Color(0xFF3B82F6)},
    {'id': 'low', 'label': 'Low', 'icon': '??', 'color': Color(0xFFF59E0B)},
    {'id': 'stressed', 'label': 'Stressed', 'icon': '??', 'color': Color(0xFFEF4444)},
  ];

  @override
  void initState() {
    super.initState();
    context.read<MoodCubit>().load();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveMood() {
    if (_selectedMood == null) return;
    context.read<MoodCubit>().logMood(
      _selectedMood!,
      _stressLevel.toInt(),
      _energyLevel.toInt(),
      _notesController.text,
    );
    Navigator.pop(context);
    UIHelpers.showSuccessSnackBar(context, 'Mood logged successfully!');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: const Text('Log Mood')),
      body: BlocConsumer<MoodCubit, MoodState>(
        listener: (context, state) {
          if (state is MoodLoaded && !_isDataLoaded) {
            setState(() {
              if (state.data.logs.isNotEmpty) {
                final log = state.data.logs.first;
                _selectedMood = log.mood.isNotEmpty ? log.mood : null;
                _stressLevel = (log.stressLevel ?? 0) > 0 ? log.stressLevel!.toDouble() : 3.0;
                _energyLevel = (log.energyLevel ?? 0) > 0 ? log.energyLevel!.toDouble() : 3.0;
                _notesController.text = log.note ?? '';
              }
              _isDataLoaded = true;
            });
          }
        },
        builder: (context, state) {
          if (state is MoodLoading && !_isDataLoaded) {
            return const Center(child: CircularProgressIndicator(color: AppColors.fitOrange));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Text('How are you feeling today?', style: GoogleFonts.dmSans(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                const SizedBox(height: 48),
                Wrap(
                  spacing: 16,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: _moods.map((m) {
                    final id = m['id'] as String;
                    final isSelected = _selectedMood == id;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMood = id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 80,
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: isSelected ? (m['color'] as Color).withValues(alpha: 0.15) : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? (m['color'] as Color) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(m['icon'] as String, style: const TextStyle(fontSize: 32)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              m['label'] as String,
                              style: GoogleFonts.inter(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? (m['color'] as Color) : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 48),
                _buildSlider(isDark, 'Stress Level', _stressLevel, (v) => setState(() => _stressLevel = v)),
                const SizedBox(height: 32),
                _buildSlider(isDark, 'Energy Level', _energyLevel, (v) => setState(() => _energyLevel = v)),
                const SizedBox(height: 48),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Add a note (optional)', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  style: GoogleFonts.inter(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Why do you feel this way?',
                    hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 14),
                    border: OutlineInputBorder(borderRadius: AppRadius.borderXl, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                    enabledBorder: OutlineInputBorder(borderRadius: AppRadius.borderXl, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                    focusedBorder: OutlineInputBorder(borderRadius: AppRadius.borderXl, borderSide: const BorderSide(color: AppColors.fitOrange)),
                    filled: true,
                    fillColor: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.fitOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                    ),
                    onPressed: _selectedMood != null ? _saveMood : null,
                    child: Text('Save Log', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlider(bool isDark, String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('/5', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.fitOrange)),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.fitOrange,
            inactiveTrackColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            thumbColor: AppColors.fitOrange,
            overlayColor: AppColors.fitOrange.withValues(alpha: 0.2),
            trackHeight: 8,
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
