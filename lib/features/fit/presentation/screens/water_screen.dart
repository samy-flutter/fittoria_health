import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../cubit/water_cubit.dart';
import '../../data/models/fit_models.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final int _goalWaterMl = 2500;
  final String todayStr = DateTime.now().toIso8601String().substring(0, 10);

  @override
  void initState() {
    super.initState();
    context.read<WaterCubit>().load(todayStr);
  }

  void _addWater(int amount) {
    context.read<WaterCubit>().logWater(todayStr, amount);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const accentColor = Color(0xFF3B82F6);

    return Scaffold(
      appBar: CustomAppBar(title: const Text('Water Intake')),
      body: BlocBuilder<WaterCubit, WaterState>(
        builder: (context, state) {
          if (state is WaterLoading) {
            return const Center(child: CircularProgressIndicator(color: accentColor));
          } else if (state is WaterError) {
            return Center(child: Text(state.message));
          } else if (state is WaterLoaded) {
            final data = state.data;
            final progress = (data.totalMl / _goalWaterMl).clamp(0.0, 1.0);

            return RefreshIndicator(
              color: accentColor,
              onRefresh: () => context.read<WaterCubit>().load(todayStr, silently: true),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildProgressCircle(isDark, accentColor, data.totalMl, progress),
                    const SizedBox(height: 48),
                    Text(
                      progress >= 1.0 ? 'Daily Goal Reached! ??' : 'Keep hydrating!',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(child: _buildActionButton(isDark, accentColor, 250)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildActionButton(isDark, accentColor, 500)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildActionButton(isDark, accentColor, 750)),
                      ],
                    ),
                    const SizedBox(height: 48),
                    _buildChartCard(isDark, accentColor, data.week),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProgressCircle(bool isDark, Color accentColor, int currentMl, double progress) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: BorderRadius.circular(1000), // Perfect circle background
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 16,
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 16,
              color: accentColor,
              strokeCap: StrokeCap.round,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.droplets, color: accentColor, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '${(currentMl / 1000).toStringAsFixed(1)}L',
                    style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                  Text(
                    'of ${(_goalWaterMl / 1000).toStringAsFixed(1)}L',
                    style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(bool isDark, Color accentColor, int amount) {
    return GestureDetector(
      onTap: () => _addWater(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
          borderRadius: AppRadius.borderXl,
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          children: [
            Icon(LucideIcons.droplet, color: accentColor, size: 24),
            const SizedBox(height: 8),
            Text('+$amount ml', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(bool isDark, Color accentColor, List<WaterWeekData> week) {
    // Map the 7 days of data correctly.
    // Ensure we have exactly 7 elements, fill missing ones if necessary.
    final DateTime now = DateTime.now();
    List<double> weekData = List.filled(7, 0.0);
    List<String> dayLabels = List.filled(7, '');
    
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      dayLabels[i] = DateFormat('E').format(date).substring(0, 1);
      final dateStr = date.toIso8601String().substring(0, 10);
      final entry = week.cast<WaterWeekData?>().firstWhere((e) => e?.logDate == dateStr, orElse: () => null);
      if (entry != null) {
        weekData[i] = entry.ml.toDouble();
      }
    }

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
          Text('Weekly Intake', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < 7) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(dayLabels[idx], style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 10)),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) => _makeGroupData(i, weekData[i], accentColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 2500,
            color: color.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}
