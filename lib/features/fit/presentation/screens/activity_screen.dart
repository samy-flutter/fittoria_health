import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../data/models/fit_models.dart';
import '../cubit/activity_cubit.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _range = 'week';

  @override
  void initState() {
    super.initState();
    context.read<ActivityCubit>().load(_range);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Activity'),
        ),
      body: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, state) {
          if (state is ActivityInitial || state is ActivityLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE8843C)));
          }
          if (state is ActivityError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          if (state is ActivityLoaded) {
            final data = state.data;
            final totals = data.totals;

            return RefreshIndicator(
              color: const Color(0xFFE8843C),
              onRefresh: () => context.read<ActivityCubit>().load(_range, silently: true),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRangeToggle(),
                    const SizedBox(height: 16),
                    _buildChartCard(isDark, data),
                    const SizedBox(height: 16),
                    _buildTotalsGrid(totals, isDark),
                    const SizedBox(height: 16),
                    _buildHistoryList(isDark, data),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE8843C),
        child: const Icon(LucideIcons.plus, color: Colors.white),
        onPressed: () => _showLogDialog(context, const Color(0xFFE8843C)),
      ),
    );
  }

  void _showLogDialog(BuildContext context, Color accentColor) {
    int steps = 5000;
    int minutes = 30;
    showDialog(
      context: context,
      builder: (dContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Log Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$steps steps', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text('Steps'),
              Slider(
                value: steps.toDouble(),
                min: 0,
                max: 30000,
                divisions: 300,
                activeColor: accentColor,
                onChanged: (v) => setState(() => steps = v.toInt()),
              ),
              const SizedBox(height: 16),
              Text('$minutes min active', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Slider(
                value: minutes.toDouble(),
                min: 0,
                max: 300,
                divisions: 60,
                activeColor: accentColor,
                onChanged: (v) => setState(() => minutes = v.toInt()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dContext), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {
                final log = ActivityLog(
                  steps: steps,
                  distanceKm: steps * 0.000762, // roughly 0.762 meters per step
                  caloriesKcal: (steps * 0.04).toInt(), // roughly 0.04 kcal per step
                  activeMinutes: minutes,
                  logDate: DateTime.now(),
                );
                this.context.read<ActivityCubit>().log(log, _range);
                Navigator.pop(dContext);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
            borderRadius: AppRadius.borderLg,
          ),
          child: Row(
            children: ['week', 'month'].map((r) {
              final isSelected = _range == r;
              return GestureDetector(
                onTap: () {
                  setState(() => _range = r);
                  context.read<ActivityCubit>().load(r);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE8843C) : Colors.transparent,
                    borderRadius: AppRadius.borderLg,
                  ),
                  child: Text(
                    r[0].toUpperCase() + r.substring(1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(bool isDark, ActivityData data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Step Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(NumberFormat.decimalPattern().format(data.totals.steps), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 15000,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= data.series.length) return const SizedBox.shrink();
                        final d = data.series[data.series.length - 1 - value.toInt()];
                        final title = DateFormat('E').format(d.logDate).substring(0, 1);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(title, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 10)),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5000,
                  getDrawingHorizontalLine: (value) => FlLine(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(data.series.length, (i) {
                  final log = data.series[data.series.length - 1 - i];
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: log.steps.toDouble(),
                        color: const Color(0xFFE8843C),
                        width: 8,
                        borderRadius: AppRadius.borderSm,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsGrid(ActivityLog totals, bool isDark) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _MetricCard(title: 'Total Steps', value: NumberFormat.decimalPattern().format(totals.steps), unit: '', icon: LucideIcons.footprints, color: const Color(0xFFE8843C)),
        _MetricCard(title: 'Distance', value: totals.distanceKm.toStringAsFixed(1), unit: 'km', icon: LucideIcons.mapPin, color: const Color(0xFF3B82F6)),
        _MetricCard(title: 'Calories', value: NumberFormat.decimalPattern().format(totals.caloriesKcal), unit: 'kcal', icon: LucideIcons.flame, color: const Color(0xFFEF4444)),
        _MetricCard(title: 'Active Time', value: totals.activeMinutes.toString(), unit: 'min', icon: LucideIcons.clock, color: const Color(0xFF8B5CF6)),
      ],
    );
  }

  Widget _buildHistoryList(bool isDark, ActivityData data) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: const Text('Daily Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          if (data.series.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text('No entries yet.', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.series.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              itemBuilder: (context, index) {
                final log = data.series[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('EEEE, MMM d').format(log.logDate), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${log.distanceKm.toStringAsFixed(1)} km  •  ${log.caloriesKcal} kcal  •  ${log.activeMinutes} min', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(NumberFormat.decimalPattern().format(log.steps), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('steps', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _MetricCard({required this.title, required this.value, required this.unit, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: AppRadius.borderLg,
                ),
                child: Icon(icon, color: color, size: 14),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(unit, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12)),
              ],
            ],
          ),
          Text(title, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
