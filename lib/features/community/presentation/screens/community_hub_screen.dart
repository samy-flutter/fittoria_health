import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/hub_grid.dart';
import '../../../../routes/route_names.dart';

class CommunityHubScreen extends StatelessWidget {
  const CommunityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: HubGrid(
        title: 'Community',
        subtitle: 'Connect, compete & celebrate',
        icon: LucideIcons.users,
        sections: [
          HubGridSectionData(
            title: 'Social',
            items: [
              const HubGridItem(
                route: RouteNames.patientSocial,
                label: 'Community Feed',
                desc: 'Share & inspire',
                icon: LucideIcons.users,
                color: Color(0xFF3B82F6),
              ),
              const HubGridItem(
                route: RouteNames.patientClubs, // Not currently defined in our placeholder list, let's map it to placeholder
                label: 'Clubs',
                desc: 'Group chats',
                icon: LucideIcons.messageCircle,
                color: Color(0xFFE8843C),
              ),
            ],
          ),
          HubGridSectionData(
            title: 'Compete',
            items: [
              const HubGridItem(
                route: RouteNames.patientAchievements,
                label: 'Achievements',
                desc: 'Points & rank',
                icon: LucideIcons.trophy,
                color: Color(0xFFF59E0B),
              ),
              const HubGridItem(
                route: RouteNames.patientEvents,
                label: 'Events',
                desc: 'Marathons & rides',
                icon: LucideIcons.flag,
                color: Color(0xFFEF4444),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
