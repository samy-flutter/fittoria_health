import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../routes/route_names.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class LogDataScreen extends StatelessWidget {
  const LogDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: Text('Quick Log')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8843C).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    LucideIcons.footprints,
                    color: Color(0xFFE8843C),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Log',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'What do you want to track?',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
              children: [
                _buildActionCard(
                  context,
                  isDark,
                  'Activity',
                  'Steps, distance, calories',
                  RouteNames.patientFitActivity,
                  LucideIcons.footprints,
                  const Color(0xFFE8843C),
                ),
                _buildActionCard(
                  context,
                  isDark,
                  'Workout',
                  'Log a training session',
                  RouteNames.patientFitWorkouts,
                  LucideIcons.dumbbell,
                  const Color(0xFFE8843C),
                ),
                _buildActionCard(
                  context,
                  isDark,
                  'Heart Rate',
                  'Record a BPM reading',
                  RouteNames.patientFitHeartRate,
                  LucideIcons.heart,
                  const Color(0xFFEF4444),
                ),
                _buildActionCard(
                  context,
                  isDark,
                  'Sleep',
                  'Track last night',
                  RouteNames.patientFitSleep,
                  LucideIcons.moon,
                  const Color(0xFF8B5CF6),
                ),
                _buildActionCard(
                  context,
                  isDark,
                  'Nutrition',
                  'Add food & macros',
                  RouteNames.patientFitNutrition,
                  LucideIcons.apple,
                  const Color(0xFF22C55E),
                ),
                _buildActionCard(
                  context,
                  isDark,
                  'Water',
                  'Log hydration',
                  RouteNames.patientFitWater,
                  LucideIcons.droplet,
                  const Color(0xFF3B82F6),
                ),
                _buildActionCard(
                  context,
                  isDark,
                  'Mood',
                  'Check-in your mood',
                  RouteNames.patientFitMood,
                  LucideIcons.smile,
                  const Color(0xFFF59E0B),
                ),
                _buildActionCard(
                  context,
                  isDark,
                  'Body',
                  'Weight & measurements',
                  RouteNames.patientBodyProgress,
                  LucideIcons.scale,
                  const Color(0xFFA855F7),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    bool isDark,
    String label,
    String desc,
    String route,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
          borderRadius: AppRadius.borderXl,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
