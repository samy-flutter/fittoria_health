import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/presentation/widgets/hub_grid.dart';
import '../../../../routes/route_names.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class CareHubScreen extends StatelessWidget {
  const CareHubScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Care'),
        isBackButtonVisible: false,
      ),
        body: HubGrid(
          title: 'Care & Health',
          subtitle: 'Your team, clinics & records',
        icon: LucideIcons.heart,
        sections: [
          HubGridSectionData(
            title: 'My Care Team',
            items: [
              const HubGridItem(
                route: RouteNames.patientGym,
                label: 'Gym',
                desc: 'Membership',
                icon: LucideIcons.building2,
                color: Color(0xFFFB7C37),
              ),
              const HubGridItem(
                route: RouteNames.patientTrainers,
                label: 'Find Trainer',
                desc: 'Book a coach',
                icon: LucideIcons.userPlus,
                color: Color(0xFF22C55E),
              ),
              const HubGridItem(
                route: RouteNames.patientFitness,
                label: 'My Trainer',
                desc: 'Plans & progress',
                icon: LucideIcons.dumbbell,
                color: Color(0xFF22C55E),
              ),
              const HubGridItem(
                route: RouteNames.patientNutrition,
                label: 'My Dietitian',
                desc: 'Meal plans',
                icon: LucideIcons.salad,
                color: Color(0xFFA78BFA),
              ),
              const HubGridItem(
                route: RouteNames.patientMeetings,
                label: 'Meetings',
                desc: 'Video consults',
                icon: LucideIcons.video,
                color: Color(0xFFF472B6),
              ),
              const HubGridItem(
                // Reports in original Next.js codebase goes to coach insights.
                route: RouteNames.patientReports,
                label: 'Reports',
                desc: 'Coach insights',
                icon: LucideIcons.barChart3,
                color: Color(0xFF3B82F6),
              ),
            ],
          ),
          HubGridSectionData(
            title: 'Clinic & Doctors',
            items: [
              const HubGridItem(
                route: RouteNames.patientClinics,
                label: 'Clinics',
                desc: 'Find a clinic',
                icon: LucideIcons.building2,
                color: Color(0xFF0D6E6E),
              ),
              const HubGridItem(
                route: RouteNames.patientBook,
                label: 'Book Appt',
                desc: 'New appointment',
                icon: LucideIcons.calendarDays,
                color: Color(0xFF0D6E6E),
              ),
              const HubGridItem(
                route: RouteNames.patientAppointments,
                label: 'Appointments',
                desc: 'Your visits',
                icon: LucideIcons.stethoscope,
                color: Color(0xFF00D4B4),
              ),
              const HubGridItem(
                route: RouteNames.patientPrescriptions,
                label: 'Prescriptions',
                desc: 'Your Rx',
                icon: LucideIcons.pill,
                color: Color(0xFFE8A045),
              ),
            ],
          ),
          HubGridSectionData(
            title: 'Diagnostics & Records',
            items: [
              const HubGridItem(
                route: RouteNames.patientLabBooking,
                label: 'Book Lab Test',
                desc: 'Home / clinic',
                icon: LucideIcons.flaskConical,
                color: Color(0xFF00D4B4),
              ),
              const HubGridItem(
                route: RouteNames.patientLabReports,
                label: 'Lab Reports',
                desc: 'Results',
                icon: LucideIcons.flaskConical,
                color: Color(0xFF7e22ce),
              ),
              const HubGridItem(
                route: RouteNames.patientLabReferrals,
                label: 'Lab Referrals',
                desc: 'Referred tests',
                icon: LucideIcons.flaskConical,
                color: Color(0xFF7e22ce),
              ),
              const HubGridItem(
                route: RouteNames.patientRecords,
                label: 'Health Records',
                desc: 'Full history',
                icon: LucideIcons.activity,
                color: Color(0xFFEF4444),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
