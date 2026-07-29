import '../../../../core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../routes/route_names.dart';
import '../cubit/workouts_cubit.dart';
import '../../data/models/fitness_hub_models.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _avgHrController = TextEditingController();

  String _selectedType = 'running';

  final List<Map<String, String>> _types = [
    {'key': 'running', 'label': 'Running', 'emoji': '🏃'},
    {'key': 'walking', 'label': 'Walking', 'emoji': '🚶'},
    {'key': 'cycling', 'label': 'Cycling', 'emoji': '🚴'},
    {'key': 'gym', 'label': 'Gym', 'emoji': '🏋️'},
    {'key': 'yoga', 'label': 'Yoga', 'emoji': '🧘'},
    {'key': 'swimming', 'label': 'Swimming', 'emoji': '🏊'},
    {'key': 'hiit', 'label': 'HIIT', 'emoji': '⚡'},
    {'key': 'other', 'label': 'Other', 'emoji': '💪'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<WorkoutsCubit>().loadWorkouts();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _distanceController.dispose();
    _caloriesController.dispose();
    _avgHrController.dispose();
    super.dispose();
  }

  void _saveLog() {
    if (_durationController.text.isEmpty) return;
    
    final type = _selectedType;
    final title = _titleController.text.isEmpty ? null : _titleController.text;
    final duration = int.tryParse(_durationController.text) ?? 0;
    final distance = double.tryParse(_distanceController.text) ?? 0.0;
    final calories = int.tryParse(_caloriesController.text) ?? 0;
    final avgHr = _avgHrController.text.isEmpty ? null : int.tryParse(_avgHrController.text);
    
    context.read<WorkoutsCubit>().log(type, title, duration, distance, calories, avgHr);

    UIHelpers.showSuccessSnackBar(context, 'Workout logged successfully!');
  }

  void _showManualLogModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
                  ),
                  Text('Log Workout', style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: _types.length,
                            itemBuilder: (ctx, i) {
                              final t = _types[i];
                              final isSelected = _selectedType == t['key'];
                              return GestureDetector(
                                onTap: () => setModalState(() => _selectedType = t['key']!),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.fitOrange.withValues(alpha: 0.1) : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isSelected ? AppColors.fitOrange : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(t['emoji']!, style: const TextStyle(fontSize: 20)),
                                      const SizedBox(height: 4),
                                      Text(t['label']!, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? AppColors.fitOrange : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildInputCol('Title (optional)', '', _titleController, isDark, TextInputType.text),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildInputCol('Duration', 'min', _durationController, isDark, TextInputType.number)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildInputCol('Distance', 'km', _distanceController, isDark, TextInputType.number)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildInputCol('Calories', 'kcal', _caloriesController, isDark, TextInputType.number)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildInputCol('Avg HR', 'bpm', _avgHrController, isDark, TextInputType.number)),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.fitOrange,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _saveLog();
                        },
                        child: Text('Save Log', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputCol(String label, String suffix, TextEditingController controller, bool isDark, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: type,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true),
                ),
              ),
              if (suffix.isNotEmpty) Text(suffix, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Workouts'),
        ),
      body: BlocBuilder<WorkoutsCubit, WorkoutsState>(
        builder: (context, state) {
          if (state is WorkoutsLoading || state is WorkoutsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WorkoutsError) {
            return Center(child: Text(state.message));
          }

          FitWorkoutData data = FitWorkoutData(stats: FitWorkoutStats());
          if (state is WorkoutsLoaded) {
            data = state.data;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.fitOrange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                      ),
                    onPressed: () => context.push(RouteNames.patientFitRecord),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.mapPin, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text('Record with GPS', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderXl,
                      side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    ),
                  onPressed: () => _showManualLogModal(context, isDark),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.plus, size: 18),
                      const SizedBox(width: 8),
                      Text('Manual', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(isDark, 'Sessions', data.stats.total.toString(), '', AppColors.fitOrange, LucideIcons.activity),
                _buildStatCard(isDark, 'Total Time', '${data.stats.minutes}m', '', const Color(0xFF8B5CF6), LucideIcons.clock),
                _buildStatCard(isDark, 'Burned', data.stats.calories.toString(), 'kcal', const Color(0xFFEF4444), LucideIcons.flame),
                _buildStatCard(isDark, 'Distance', data.stats.distanceKm.toString(), 'km', const Color(0xFF3B82F6), LucideIcons.mapPin),
              ],
            ),
            const SizedBox(height: 32),
            Text('Recent Sessions', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            if (data.workouts.isEmpty)
              Text('No recent workouts logged.', style: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))
            else
              ...data.workouts.map((h) => _buildHistoryCard(
                    isDark,
                    h.title ?? h.workoutType,
                    _getEmoji(h.workoutType),
                    '${h.durationMin}m',
                    h.distanceKm > 0 ? '${h.distanceKm} km' : null,
                    '${h.caloriesKcal} kcal',
                    '${h.avgHeartRate ?? '-'} bpm',
                    h.startedAt.split('T').first,
                  )),
          ],
        ),
      );
      },
      ),
    );
  }

  String _getEmoji(String type) {
    final match = _types.firstWhere((t) => t['key'] == type.toLowerCase(), orElse: () => {'emoji': '💪'});
    return match['emoji']!;
  }

  Widget _buildStatCard(bool isDark, String label, String value, String unit, Color accent, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 16),
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(unit, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(bool isDark, String title, String emoji, String duration, String? distance, String calories, String hr, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
              borderRadius: AppRadius.borderLg,
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    Text(duration, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    if (distance != null) Text('· $distance', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    Text('· $calories', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    Text('· $hr', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  ],
                ),
              ],
            ),
          ),
          Text(date, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        ],
      ),
    );
  }
}
