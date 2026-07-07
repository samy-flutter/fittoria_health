import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/presentation/widgets/hub_grid.dart';
import '../../../../routes/route_names.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class FitnessHubScreen extends StatelessWidget {
  const FitnessHubScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Fitness'),
        isBackButtonVisible: false,
      ),
        body: HubGrid(
          title: 'Fitness Tracking',
          subtitle: 'Track every part of your training',
        icon: LucideIcons.footprints,
        sections: [
          HubGridSectionData(
            title: 'Track',
            items: [
              const HubGridItem(
                route: RouteNames.patientFitRecord,
                label: 'Record (GPS)',
                desc: 'Live map run/ride',
                icon: LucideIcons.mapPin,
                color: Color(0xFFE8843C),
              ),
              const HubGridItem(
                route: RouteNames.patientFitActivity,
                label: 'Activity',
                desc: 'Steps & calories',
                icon: LucideIcons.footprints,
                color: Color(0xFFE8843C),
              ),
              const HubGridItem(
                route: RouteNames.patientFitWorkouts,
                label: 'Workouts',
                desc: 'Sessions log',
                icon: LucideIcons.dumbbell,
                color: Color(0xFF22C55E),
              ),
              const HubGridItem(
                route: RouteNames.patientFitPrograms,
                label: 'Programs',
                desc: 'Training plans',
                icon: LucideIcons.activity,
                color: Color(0xFF3B82F6),
              ),
            ],
          ),
          HubGridSectionData(
            title: 'Vitals & Wellness',
            items: [
              const HubGridItem(
                route: RouteNames.patientFitHeartRate,
                label: 'Heart Rate',
                desc: 'BPM readings',
                icon: LucideIcons.heart,
                color: Color(0xFFEF4444),
              ),
              const HubGridItem(
                route: RouteNames.patientFitSleep,
                label: 'Sleep',
                desc: 'Rest & quality',
                icon: LucideIcons.moon,
                color: Color(0xFF8B5CF6),
              ),
              const HubGridItem(
                route: RouteNames.patientFitWater,
                label: 'Water',
                desc: 'Hydration',
                icon: LucideIcons.droplet,
                color: Color(0xFF3B82F6),
              ),
              const HubGridItem(
                route: RouteNames.patientFitMood,
                label: 'Mood',
                desc: 'Daily check-in',
                icon: LucideIcons.smile,
                color: Color(0xFFF59E0B),
              ),
            ],
          ),
          HubGridSectionData(
            title: 'Nutrition',
            items: [
              const HubGridItem(
                route: RouteNames.patientFitNutrition,
                label: 'Food Log',
                desc: 'Log meals',
                icon: LucideIcons.apple,
                color: Color(0xFF22C55E),
              ),
              const HubGridItem(
                route: RouteNames.patientAiNutrition,
                label: 'AI Nutritionist',
                desc: 'Photo to macros',
                icon: LucideIcons.sparkles,
                color: Color(0xFFE8843C),
              ),
            ],
          ),
          HubGridSectionData(
            title: 'Goals & Progress',
            items: [
              const HubGridItem(
                route: RouteNames.patientFitGoals,
                label: 'Goals',
                desc: 'Set & track',
                icon: LucideIcons.target,
                color: Color(0xFFE8843C),
              ),
              const HubGridItem(
                route: RouteNames.patientChallenges,
                label: 'Challenges',
                desc: 'Compete',
                icon: LucideIcons.trophy,
                color: Color(0xFFF59E0B),
              ),
              const HubGridItem(
                route: RouteNames.patientBodyProgress,
                label: 'Body Progress',
                desc: 'Measurements',
                icon: LucideIcons.scale,
                color: Color(0xFFA855F7),
              ),
              const HubGridItem(
                route: RouteNames.patientFitDevices,
                label: 'Devices',
                desc: 'Connections',
                icon: LucideIcons.watch,
                color: Color(0xFF6B7280),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
