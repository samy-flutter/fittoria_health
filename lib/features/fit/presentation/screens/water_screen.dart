import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  int _currentWaterMl = 1250;
  final int _goalWaterMl = 2500;

  void _addWater(int amount) {
    setState(() {
      _currentWaterMl = min(_currentWaterMl + amount, _goalWaterMl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const accentColor = Color(0xFF3B82F6);
    final progress = _currentWaterMl / _goalWaterMl;

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Water Intake'),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
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
                            '${(_currentWaterMl / 1000).toStringAsFixed(1)}L',
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
            ),
            const SizedBox(height: 48),
            Text(
              progress >= 1.0 ? 'Daily Goal Reached! 🎉' : 'Keep hydrating!',
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
            _buildChartCard(isDark, accentColor),
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
            Text('+${amount}ml', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(bool isDark, Color accentColor) {
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
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(days[value.toInt()], style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 10)),
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
                barGroups: [
                  _makeGroupData(0, 1800, accentColor),
                  _makeGroupData(1, 2200, accentColor),
                  _makeGroupData(2, 2500, accentColor),
                  _makeGroupData(3, 1500, accentColor),
                  _makeGroupData(4, 2500, accentColor),
                  _makeGroupData(5, 2000, accentColor),
                  _makeGroupData(6, _currentWaterMl.toDouble(), accentColor),
                ],
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
