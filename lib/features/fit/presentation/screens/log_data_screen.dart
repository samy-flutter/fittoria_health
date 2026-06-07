import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/hub_grid.dart';
import '../../../../routes/route_names.dart';

class LogDataScreen extends StatelessWidget {
  const LogDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('Quick Log'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: HubGrid(
        title: 'Quick Log',
        subtitle: 'What do you want to track?',
        icon: LucideIcons.footprints,
        sections: [
          HubGridSectionData(
            title: '',
            items: [
              const HubGridItem(
                route: RouteNames.patientFitActivity,
                label: 'Activity',
                desc: 'Steps, distance, calories',
                icon: LucideIcons.footprints,
                color: Color(0xFFE8843C),
              ),
              const HubGridItem(
                route: RouteNames.patientFitWorkouts,
                label: 'Workout',
                desc: 'Log a training session',
                icon: LucideIcons.dumbbell,
                color: Color(0xFFE8843C),
              ),
              const HubGridItem(
                route: RouteNames.patientFitHeartRate,
                label: 'Heart Rate',
                desc: 'Record a BPM reading',
                icon: LucideIcons.heart,
                color: Color(0xFFEF4444),
              ),
              const HubGridItem(
                route: RouteNames.patientFitSleep,
                label: 'Sleep',
                desc: 'Track last night',
                icon: LucideIcons.moon,
                color: Color(0xFF8B5CF6),
              ),
              const HubGridItem(
                route: RouteNames.patientFitNutrition,
                label: 'Nutrition',
                desc: 'Add food & macros',
                icon: LucideIcons.apple,
                color: Color(0xFF22C55E),
              ),
              const HubGridItem(
                route: RouteNames.patientFitWater,
                label: 'Water',
                desc: 'Log hydration',
                icon: LucideIcons.droplet,
                color: Color(0xFF3B82F6),
              ),
              const HubGridItem(
                route: RouteNames.patientFitMood,
                label: 'Mood',
                desc: 'Check-in your mood',
                icon: LucideIcons.smile,
                color: Color(0xFFF59E0B),
              ),
              const HubGridItem(
                route: RouteNames.patientBodyProgress,
                label: 'Body',
                desc: 'Weight & measurements',
                icon: LucideIcons.scale,
                color: Color(0xFFA855F7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
