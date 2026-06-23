import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../cubit/heart_rate_cubit.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/models/fit_models.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HeartRateCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const accentColor = Color(0xFFEF4444);

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Heart Rate'),
        ),
      body: BlocBuilder<HeartRateCubit, HeartRateState>(
        builder: (context, state) {
          if (state is HeartRateInitial || state is HeartRateLoading) {
            return const Center(child: CircularProgressIndicator(color: accentColor));
          }
          if (state is HeartRateError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          if (state is HeartRateLoaded) {
            final data = state.data;
            final stats = data.stats;

            return RefreshIndicator(
              color: accentColor,
              onRefresh: () => context.read<HeartRateCubit>().load(silently: true),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsGrid(stats, isDark),
                    const SizedBox(height: 16),
                    _buildChartCard(isDark, data, accentColor),
                    const SizedBox(height: 16),
                    _buildHistoryList(isDark, data, accentColor),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        child: const Icon(LucideIcons.plus, color: Colors.white),
        onPressed: () => _showLogDialog(context, accentColor),
      ),
    );
  }

  void _showLogDialog(BuildContext context, Color accentColor) {
    int bpm = 75;
    String type = 'spot';
    showDialog(
      context: context,
      builder: (dContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Log Heart Rate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$bpm bpm', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Slider(
                value: bpm.toDouble(),
                min: 40,
                max: 200,
                activeColor: accentColor,
                onChanged: (v) => setState(() => bpm = v.toInt()),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['resting', 'active', 'spot', 'recovery'].map((t) {
                  final isSelected = type == t;
                  return ChoiceChip(
                    label: Text(t[0].toUpperCase() + t.substring(1), style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    selectedColor: accentColor.withValues(alpha: 0.2),
                    onSelected: (selected) {
                      if (selected) setState(() => type = t);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dContext), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {
                this.context.read<HeartRateCubit>().log(bpm, type);
                Navigator.pop(dContext);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(HeartRateStats stats, bool isDark) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _MetricCard(title: 'Resting', value: stats.restingBpm?.toString() ?? '—', unit: 'bpm', icon: LucideIcons.heart, color: const Color(0xFFEF4444)),
        _MetricCard(title: 'Avg (7d)', value: stats.avgBpm?.toString() ?? '—', unit: 'bpm', icon: LucideIcons.activity, color: const Color(0xFFF59E0B)),
        _MetricCard(title: 'Peak', value: stats.maxBpm?.toString() ?? '—', unit: 'bpm', icon: LucideIcons.heart, color: const Color(0xFF8B5CF6)),
      ],
    );
  }

  Widget _buildChartCard(bool isDark, data, Color accentColor) {
    final readings = List.from(data.readings.reversed.take(20).toList());

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
          const Text('Recent Trend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),
          if (readings.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: Center(child: Text('No readings yet.')))
          else
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) => FlLine(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString(), style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 10));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (readings.length - 1).toDouble(),
                  minY: 40,
                  maxY: 180,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(readings.length, (index) => FlSpot(index.toDouble(), readings[index].bpm.toDouble())),
                      isCurved: true,
                      color: accentColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: accentColor.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(bool isDark, data, Color accentColor) {
    const typeLabel = {'resting': 'Resting', 'active': 'Active', 'spot': 'Spot Check', 'recovery': 'Recovery'};

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
            child: const Text('History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          if (data.readings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text('No readings logged.', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.readings.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              itemBuilder: (context, index) {
                final r = data.readings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.heart, color: accentColor, size: 16),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${r.bpm} bpm', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text(typeLabel[r.readingType] ?? r.readingType, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      Text(DateFormat('MMM d, h:mm a').format(r.measuredAt), style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 12)),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadius.borderLg,
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(unit, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 10)),
              ],
            ],
          ),
          Text(title, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
