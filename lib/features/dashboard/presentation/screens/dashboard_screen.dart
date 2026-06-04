import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../../../appointments/data/models/appointment.dart';
import '../../../profile_records/data/models/profile_models.dart';

extension NavigationExtension on BuildContext {
  void navigateTo(String route) {
    if (route == '/patient/appointments' || 
        route == '/patient/clinics' || 
        route == '/patient/profile' || 
        route == '/patient/dashboard') {
      go(route);
    } else {
      push(route);
    }
  }
}

// ─── Constants matching Next.js page.tsx ─────────────────────────────────────

const _kDarkGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.0, 0.60, 1.0],
  colors: [Color(0xFF0A4F4F), Color(0xFF073E3E), Color(0xFF051C1C)],
);

// Wellness tips rotating by day-of-year (matches WELLNESS_TIPS in page.tsx)
const _wellnessTips = [
  _WellnessTip(
    icon: LucideIcons.droplets,
    color: Color(0xFF1D4ED8),
    bg: Color(0xFFDBEAFE),
    tip: 'Drink at least 8 glasses of water today to stay hydrated.',
  ),
  _WellnessTip(
    icon: LucideIcons.activity,
    color: Color(0xFF0D6E6E),
    bg: Color(0xFFE0F4F4),
    tip: '30 minutes of brisk walking can significantly boost your heart health.',
  ),
  _WellnessTip(
    icon: LucideIcons.heart,
    color: Color(0xFFBE123C),
    bg: Color(0xFFFFE4E6),
    tip: 'Aim for 7–8 hours of quality sleep to let your body recover.',
  ),
  _WellnessTip(
    icon: LucideIcons.utensils,
    color: Color(0xFFC2410C),
    bg: Color(0xFFFFEDD5),
    tip: 'Eat 5 servings of fruits & vegetables for essential vitamins.',
  ),
  _WellnessTip(
    icon: LucideIcons.wind,
    color: Color(0xFF7E22CE),
    bg: Color(0xFFF3E8FF),
    tip: 'Take 5 deep breaths every hour at your desk to reduce stress.',
  ),
  _WellnessTip(
    icon: LucideIcons.checkCircle2,
    color: Color(0xFF15803D),
    bg: Color(0xFFDCFCE7),
    tip: "Don't skip breakfast — it powers your focus through the morning.",
  ),
  _WellnessTip(
    icon: LucideIcons.trendingUp,
    color: Color(0xFF3730A3),
    bg: Color(0xFFE0E7FF),
    tip: 'Track your weight weekly at the same time for accurate trends.',
  ),
];

class _WellnessTip {
  final IconData icon;
  final Color color;
  final Color bg;
  final String tip;
  const _WellnessTip({
    required this.icon,
    required this.color,
    required this.bg,
    required this.tip,
  });
}

_WellnessTip get _dailyTip {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  return _wellnessTips[dayOfYear % _wellnessTips.length];
}

// Quick links (matches quickLinks in page.tsx)
class _QuickLink {
  final String label;
  final String desc;
  final IconData icon;
  final String route;
  final bool primary;
  const _QuickLink({
    required this.label,
    required this.desc,
    required this.icon,
    required this.route,
    this.primary = false,
  });
}

const _quickLinks = [
  _QuickLink(label: 'Book Appointment', desc: 'Find & schedule a slot',  icon: LucideIcons.plusCircle,     route: '/patient/book',          primary: true),
  _QuickLink(label: 'Prescriptions',    desc: 'View your medications',    icon: LucideIcons.pill,      route: '/patient/prescriptions'),
  _QuickLink(label: 'Lab Reports',      desc: 'Check test results',       icon: LucideIcons.flaskConical,         route: '/patient/lab-reports'),
  _QuickLink(label: 'Health Records',   desc: 'Vitals & case notes',      icon: LucideIcons.fileText,  route: '/patient/records'),
  _QuickLink(label: 'Invoices',         desc: 'Download PDF bills',       icon: LucideIcons.receipt,    route: '/patient/invoices'),
  _QuickLink(label: 'My Profile',       desc: 'Edit personal info',       icon: LucideIcons.user,          route: '/patient/profile'),
];

// Explore services (matches services in page.tsx)
class _Service {
  final String label;
  final String desc;
  final IconData icon;
  final Color color;
  final Color bg;
  final String route;
  const _Service({
    required this.label,
    required this.desc,
    required this.icon,
    required this.color,
    required this.bg,
    required this.route,
  });
}

const _services = [
  _Service(label: 'Online Consultation', desc: 'Video call with doctor', icon: LucideIcons.video,       color: Color(0xFF0D6E6E), bg: Color(0xFFE0F4F4), route: '/patient/book'),
  _Service(label: 'Health Check-ups',    desc: 'Full body packages',    icon: LucideIcons.heart,        color: Color(0xFFBE123C), bg: Color(0xFFFFE4E6), route: '/patient/book'),
  _Service(label: 'Lab Tests',           desc: 'Track your results',    icon: LucideIcons.flaskConical,         color: Color(0xFF7E22CE), bg: Color(0xFFF3E8FF), route: '/patient/lab-reports'),
  _Service(label: 'Order Medicines',     desc: 'View e-prescriptions',  icon: LucideIcons.pill,      color: Color(0xFFC2410C), bg: Color(0xFFFFEDD5), route: '/patient/prescriptions'),
];

// Specialty filter chips
const _specialties = ['General', 'Cardiology', 'Dermatology', 'Ortho'];

// ─── Main Screen ──────────────────────────────────────────────────────────────

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>()..loadDashboardData(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const _DashboardSkeleton();
          }
          if (state is DashboardError) {
            return _DashboardErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<DashboardCubit>().loadDashboardData(),
            );
          }
          if (state is DashboardLoaded) {
            return Column(
              children: [
                // Greeting strip removed (now in shell app bar)
                Expanded(child: _DashboardContent(state: state)),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─── Content ──────────────────────────────────────────────────────────────────

class _DashboardContent extends StatelessWidget {
  final DashboardLoaded state;
  const _DashboardContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.lightTeal,
      onRefresh: () => context.read<DashboardCubit>().loadDashboardData(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. Greeting card (dark gradient — matches Next.js hero)
                _GreetingCard(profile: state.profile),
                const SizedBox(height: 12),

                // 2. Pending invoice alert
                if (state.pendingInvoiceCount > 0) ...[
                  _PendingInvoiceAlert(count: state.pendingInvoiceCount),
                  const SizedBox(height: 12),
                ],

                // 3. KPI grid: Health Overview
                _SectionHeader(
                  label: 'Health Overview',
                  icon: LucideIcons.activity,
                ),
                const SizedBox(height: 8),
                _KpiGrid(state: state),
                const SizedBox(height: 16),

                // 4. Daily wellness tip
                _WellnessTipCard(tip: _dailyTip),
                const SizedBox(height: 16),

                // 5. Quick Access grid
                _SectionHeader(
                  label: 'Quick Access',
                  icon: LucideIcons.zap,
                ),
                const SizedBox(height: 8),
                _QuickAccessGrid(),
                const SizedBox(height: 16),

                // 6. Next appointment banner (if exists)
                if (state.nextAppointment != null) ...[
                  _NextAppointmentBanner(appt: state.nextAppointment!),
                  const SizedBox(height: 16),
                ],

                // 7. Upcoming appointments list + Explore Services
                _UpcomingAndServices(state: state),
                const SizedBox(height: 16),

                // 8. Recent Visits + Find Clinics CTA
                _RecentAndClinics(state: state),
                const SizedBox(height: 16),

                // 9. Trust bar
                _TrustBar(),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Greeting Card ────────────────────────────────────────────────────────────

class _GreetingCard extends StatelessWidget {
  final PatientProfile profile;
  const _GreetingCard({required this.profile});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }

  String get _emoji {
    final h = DateTime.now().hour;
    if (h < 12) return '🌅';
    if (h < 17) return '☀️';
    return '🌙';
  }

  String get _dateLabel {
    return DateFormat('EEEE, d MMMM').format(DateTime.now());
  }

  String get _firstName {
    final name = profile.fullName;
    return name.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.borderXl,
      child: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(gradient: _kDarkGradient),
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _dateLabel.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.5),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Good $_greeting, $_firstName ',
                            style: GoogleFonts.dmSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: _emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Here's your health overview for today.",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Book button
                GestureDetector(
                  onTap: () => context.navigateTo('/patient/book'),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: AppRadius.borderLg,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.plus, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Book',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Dot-grid overlay
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
          ),
          // Cyan glow blob (top-right)
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF14B8A6).withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pending Invoice Alert ────────────────────────────────────────────────────

class _PendingInvoiceAlert extends StatelessWidget {
  final int count;
  const _PendingInvoiceAlert({required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.navigateTo('/patient/invoices'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkAmberLight : AppColors.lightAmberLight,
          borderRadius: AppRadius.borderLg,
          border: Border.all(color: isDark ? AppColors.darkAmber : AppColors.lightAmberBorder),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.alertCircle,
                size: 18, color: isDark ? AppColors.darkAmberHover : AppColors.lightAmber),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$count invoice${count > 1 ? 's' : ''} pending payment',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightAmberHover,
                ),
              ),
            ),
            Icon(LucideIcons.chevronRight,
                size: 18, color: AppColors.lightAmber),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _SectionHeader({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
          const SizedBox(width: 6),
        ],
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

// ─── KPI Grid ─────────────────────────────────────────────────────────────────

class _KpiGrid extends StatelessWidget {
  final DashboardLoaded state;
  const _KpiGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kpis = [
      _KpiItem(
        label: 'My Clinics',
        value: state.clinics.length,
        icon: LucideIcons.building,
        color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
        bg: isDark ? const Color(0x1F1D4ED8) : const Color(0xFFDBEAFE),
        route: '/patient/clinics',
      ),
      _KpiItem(
        label: 'Upcoming',
        value: state.upcomingAppointments.length,
        icon: LucideIcons.calendarDays,
        color: isDark ? AppColors.darkTealHover : AppColors.lightTeal,
        bg: isDark ? AppColors.darkTealLight : AppColors.lightTealLight,
        route: '/patient/appointments',
      ),
      _KpiItem(
        label: 'Total Visits',
        value: state.totalVisits,
        icon: LucideIcons.activity,
        color: isDark ? const Color(0xFFD8B4FE) : const Color(0xFF7E22CE),
        bg: isDark ? const Color(0x1F7E22CE) : const Color(0xFFF3E8FF),
        route: '/patient/appointments',
      ),
      _KpiItem(
        label: 'Invoices',
        value: state.invoices.length,
        icon: LucideIcons.receipt,
        color: isDark ? AppColors.darkAmberHover : AppColors.lightAmber,
        bg: isDark ? AppColors.darkAmberLight : AppColors.lightAmberLight,
        route: '/patient/invoices',
      ),
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.85,
      children: kpis.map((k) => _KpiCard(kpi: k)).toList(),
    );
  }
}

class _KpiItem {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Color bg;
  final String route;
  const _KpiItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
    required this.route,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiItem kpi;
  const _KpiCard({required this.kpi});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.navigateTo(kpi.route),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
          borderRadius: AppRadius.borderLg,
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kpi.bg,
                borderRadius: AppRadius.borderMd,
              ),
              child: Icon(kpi.icon, size: 18, color: kpi.color),
            ),
            const Spacer(),
            Text(
              '${kpi.value}',
              style: GoogleFonts.dmSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              kpi.label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
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

// ─── Wellness Tip ─────────────────────────────────────────────────────────────

class _WellnessTipCard extends StatelessWidget {
  final _WellnessTip tip;
  const _WellnessTipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBgSurface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tip.bg,
              borderRadius: AppRadius.borderLg,
            ),
            child: Icon(tip.icon, size: 22, color: tip.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.sparkles, size: 12, color: tip.color),
                    const SizedBox(width: 4),
                    Text(
                      'DAILY WELLNESS TIP',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: tip.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tip.tip,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Access Grid ────────────────────────────────────────────────────────

class _QuickAccessGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.05,
      children: _quickLinks.map((link) => _QuickLinkCard(link: link)).toList(),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final _QuickLink link;
  const _QuickLinkCard({required this.link});

  @override
  Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.navigateTo(link.route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: link.primary ? (isDark ? AppColors.darkTeal : AppColors.lightTeal) : AppColors.lightBgSurface,
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: link.primary ? (isDark ? AppColors.darkTeal : AppColors.lightTeal) : AppColors.lightBorder,
          ),
          boxShadow: link.primary
              ? [
                  BoxShadow(
                    color: AppColors.lightTeal.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: link.primary
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.lightTealLight,
                borderRadius: AppRadius.borderMd,
              ),
              child: Icon(
                link.icon,
                size: 18,
                color: link.primary ? Colors.white : AppColors.lightTeal,
              ),
            ),
            const Spacer(),
            Text(
              link.label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: link.primary ? Colors.white : AppColors.lightTextPrimary,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              link.desc,
              style: GoogleFonts.inter(
                fontSize: 9,
                color: link.primary
                    ? Colors.white.withValues(alpha: 0.7)
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

// ─── Next Appointment Banner ──────────────────────────────────────────────────

class _NextAppointmentBanner extends StatelessWidget {
  final Appointment appt;
  const _NextAppointmentBanner({required this.appt});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: AppColors.lightTealBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightTeal.withValues(alpha: 0.08),
            blurRadius: 8,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header bar with gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D6E6E), Color(0xFF0891B2)],
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 14, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'NEXT APPOINTMENT',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _StatusPill(status: appt.status),
              ],
            ),
          ),
          // Body
          Container(
            color: AppColors.lightBgSurface,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.lightTealLight,
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: const Icon(Icons.medical_services_rounded,
                          size: 26, color: AppColors.lightTeal),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appt.clinicName,
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Dr. ${appt.doctorName}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  size: 11, color: AppColors.lightTextMuted),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(appt.appointmentDate),
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.lightTextMuted),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.access_time_rounded,
                                  size: 11, color: AppColors.lightTextMuted),
                              const SizedBox(width: 4),
                              Text(
                                appt.slotStart.substring(0, 5),
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: AppColors.lightTextMuted),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.lightBorder),
                const SizedBox(height: 12),
                // Action buttons
                Row(
                  children: [
                    if (appt.visitType == 'online')
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.videocam_rounded, size: 15),
                          label: const Text('Join Call'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.lightTeal,
                            side: const BorderSide(
                                color: AppColors.lightTealBorder),
                            backgroundColor: AppColors.lightTealLight,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            textStyle: GoogleFonts.inter(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    if (appt.clinicPhone != null &&
                        appt.clinicPhone!.isNotEmpty) ...[
                      if (appt.visitType == 'online') const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.phone_rounded, size: 15),
                          label: const Text('Call Clinic'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.lightTextSecondary,
                            side: const BorderSide(color: AppColors.lightBorder),
                            backgroundColor: AppColors.lightBgMuted,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            textStyle: GoogleFonts.inter(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => context.navigateTo('/patient/appointments'),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 13),
                      label: const Text('All visits'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.lightTextSecondary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        textStyle: GoogleFonts.inter(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Upcoming + Services ──────────────────────────────────────────────────────

class _UpcomingAndServices extends StatelessWidget {
  final DashboardLoaded state;
  const _UpcomingAndServices({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upcoming appointments list
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightBgSurface,
            borderRadius: AppRadius.borderXl,
            border: Border.all(color: AppColors.lightBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 16, color: AppColors.lightTeal),
                    const SizedBox(width: 8),
                    Text(
                      'Upcoming Appointments',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                    if (state.upcomingAppointments.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightTealLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.lightTealBorder),
                        ),
                        child: Text(
                          '${state.upcomingAppointments.length}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightTeal,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.navigateTo('/patient/appointments'),
                      child: Row(
                        children: [
                          Text('View all',
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.lightTeal,
                                  fontWeight: FontWeight.w500)),
                          const Icon(Icons.chevron_right_rounded,
                              size: 14, color: AppColors.lightTeal),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.lightBorder),
              // List items
              if (state.upcomingAppointments.isEmpty)
                _EmptyState(
                  icon: Icons.calendar_today_rounded,
                  message: 'No upcoming appointments',
                  ctaLabel: 'Book Now',
                  ctaRoute: '/patient/book',
                )
              else
                ...state.upcomingAppointments.take(4).map(
                      (a) => _AppointmentListTile(appt: a),
                    ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Explore Services panel
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightBgSurface,
            borderRadius: AppRadius.borderXl,
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded,
                      size: 16, color: AppColors.lightTeal),
                  const SizedBox(width: 8),
                  Text(
                    'Explore Services',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._services.map(
                (s) => _ServiceTile(service: s),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppointmentListTile extends StatelessWidget {
  final Appointment appt;
  const _AppointmentListTile({required this.appt});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkTealLight : AppColors.lightTealLight,
              borderRadius: AppRadius.borderMd,
            ),
            child: Icon(Icons.medical_services_rounded,
                size: 18, color: isDark ? AppColors.darkTealHover : AppColors.lightTeal),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appt.clinicName,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Dr. ${appt.doctorName}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(appt.appointmentDate),
                style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w500),
              ),
              Text(
                appt.slotStart.substring(0, 5),
                style: GoogleFonts.inter(
                    fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
              const SizedBox(height: 2),
              _StatusPill(status: appt.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final _Service service;
  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.navigateTo(service.route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderMd,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: service.bg,
                borderRadius: AppRadius.borderMd,
              ),
              child: Icon(service.icon, size: 18, color: service.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    service.desc,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ],
        ),
      ),
    );
  }
}

// ─── Recent Visits + Clinics CTA ──────────────────────────────────────────────

class _RecentAndClinics extends StatelessWidget {
  final DashboardLoaded state;
  const _RecentAndClinics({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Recent visits
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightBgSurface,
            borderRadius: AppRadius.borderXl,
            border: Border.all(color: AppColors.lightBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.history_rounded,
                        size: 16, color: AppColors.lightTextMuted),
                    const SizedBox(width: 8),
                    Text(
                      'Recent Visits',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.lightBorder),
              if (state.recentVisits.isEmpty)
                _EmptyState(
                  icon: Icons.medical_services_rounded,
                  message: 'No past visits yet',
                  hideButton: true,
                )
              else
                ...state.recentVisits.map(
                  (a) => _RecentVisitTile(appt: a),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Find Clinics CTA card
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightBgSurface,
            borderRadius: AppRadius.borderXl,
            border: Border.all(color: AppColors.lightBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Dark gradient hero
              Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Dot grid
                    Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
                    // Glow blob
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF14B8A6).withValues(alpha: 0.25),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.teal.withValues(alpha: 0.2),
                              borderRadius: AppRadius.borderMd,
                              border: Border.all(
                                  color: Colors.teal.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(Icons.location_on_rounded,
                                size: 20, color: Color(0xFF2DD4BF)),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Find Clinics Near You',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              Text('Top-rated doctors in your area',
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.white.withValues(alpha: 0.5))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Specialty chips + CTA
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _specialties
                          .map((s) => GestureDetector(
                                onTap: () => context.navigateTo('/patient/clinics'),
                                child: Container(
                                  height: 28,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBgMuted,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: AppColors.lightBorder),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    s,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.navigateTo('/patient/clinics'),
                        icon: const Icon(Icons.business_rounded, size: 16),
                        label: const Text('Explore All Clinics'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentVisitTile extends StatelessWidget {
  final Appointment appt;
  const _RecentVisitTile({required this.appt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.lightBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.lightBgMuted,
              borderRadius: AppRadius.borderMd,
            ),
            child: const Icon(Icons.medical_services_rounded,
                size: 16, color: AppColors.lightTextSecondary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appt.clinicName,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Dr. ${appt.doctorName} · ${_formatDate(appt.appointmentDate)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          _StatusPill(status: 'completed'),
        ],
      ),
    );
  }
}

// ─── Trust Bar ────────────────────────────────────────────────────────────────

class _TrustBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightBgSurface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Wrap(
        spacing: 0,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _TrustBadge(
            icon: Icons.shield_rounded,
            color: AppColors.success,
            label: 'HIPAA-grade security',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('·',
                style: TextStyle(
                    color: AppColors.lightBorder,
                    fontWeight: FontWeight.w700)),
          ),
          _TrustBadge(
            icon: Icons.trending_up_rounded,
            color: const Color(0xFF1D4ED8),
            label: 'End-to-end encrypted',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('·',
                style: TextStyle(
                    color: AppColors.lightBorder,
                    fontWeight: FontWeight.w700)),
          ),
          _TrustBadge(
            icon: Icons.favorite_rounded,
            color: const Color(0xFFBE123C),
            label: '24/7 Support',
          ),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  const _TrustBadge(
      {required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

// ─── Status Pill ──────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _statusColors(status, isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.$2),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: colors.$3,
        ),
      ),
    );
  }

  (Color, Color, Color) _statusColors(String status, bool isDark) {
    switch (status) {
      case 'scheduled':
        return isDark 
            ? (const Color(0x1F1D4ED8), const Color(0xFF1D4ED8), const Color(0xFF93C5FD))
            : (const Color(0xFFDBEAFE), const Color(0xFF93C5FD), const Color(0xFF1D4ED8));
      case 'waiting':
        return isDark
            ? (AppColors.darkAmberLight, AppColors.darkAmberHover, AppColors.darkAmber)
            : (AppColors.lightAmberLight, AppColors.lightAmberBorder, AppColors.lightAmberHover);
      case 'in_consultation':
        return isDark
            ? (AppColors.darkTealLight, AppColors.darkTealHover, AppColors.darkTeal)
            : (AppColors.lightTealLight, AppColors.lightTealBorder, AppColors.lightTeal);
      case 'completed':
        return isDark
            ? (AppColors.successBgDark, AppColors.successDark, AppColors.successDark)
            : (AppColors.successBgLight, AppColors.successBorderLight, AppColors.success);
      case 'cancelled':
        return isDark
            ? (AppColors.dangerBgDark, AppColors.dangerDark, AppColors.dangerDark)
            : (AppColors.dangerBgLight, AppColors.dangerBorderLight, AppColors.danger);
      case 'no_show':
        return isDark
            ? (const Color(0x1F475569), const Color(0xFF475569), const Color(0xFFCBD5E1))
            : (const Color(0xFFF1F5F9), const Color(0xFFCBD5E1), const Color(0xFF475569));
      default:
        return isDark
            ? (const Color(0x1F475569), const Color(0xFF475569), const Color(0xFFCBD5E1))
            : (const Color(0xFFF1F5F9), const Color(0xFFCBD5E1), const Color(0xFF475569));
    }
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? ctaLabel;
  final String? ctaRoute;
  final bool hideButton;

  const _EmptyState({
    required this.icon,
    required this.message,
    this.ctaLabel,
    this.ctaRoute,
    this.hideButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted,
              borderRadius: AppRadius.borderLg,
            ),
            child: Icon(icon, size: 24, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!hideButton && ctaLabel != null && ctaRoute != null) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => context.push(ctaRoute!),
              icon: const Icon(Icons.add_rounded, size: 14),
              label: Text(ctaLabel!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightTeal,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                textStyle: GoogleFonts.dmSans(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Skeleton ─────────────────────────────────────────────────────────────────

class _DashboardSkeleton extends StatefulWidget {
  const _DashboardSkeleton();

  @override
  State<_DashboardSkeleton> createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<_DashboardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = Tween(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skeletonBox(context, height: 110, radius: 16),
            const SizedBox(height: 12),
            _skeletonBox(context, height: 48, radius: 12),
            const SizedBox(height: 12),
            _skeletonBox(context, height: 18, width: 140, radius: 6),
            const SizedBox(height: 8),
            Row(children: [
              for (int i = 0; i < 4; i++) ...[
                Expanded(child: _skeletonBox(context, height: 80, radius: 12)),
                if (i < 3) const SizedBox(width: 8),
              ]
            ]),
            const SizedBox(height: 12),
            _skeletonBox(context, height: 70, radius: 12),
          ],
        ),
      ),
    );
  }

  Widget _skeletonBox(BuildContext context,
      {double? height, double? width, double radius = 8}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted).withValues(alpha: _anim.value),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────

class _DashboardErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardErrorView(
      {required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark ? AppColors.dangerBgDark : AppColors.dangerBgLight,
                borderRadius: AppRadius.borderXl,
              ),
              child:
                  Icon(Icons.wifi_off_rounded, size: 32, color: isDark ? AppColors.dangerDark : AppColors.danger),
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load dashboard',
              style: GoogleFonts.dmSans(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: GoogleFonts.inter(
                  fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dot Grid Painter ─────────────────────────────────────────────────────────

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter _) => false;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _formatDate(String dateStr) {
  try {
    final d = DateTime.parse(dateStr);
    return DateFormat('d MMM yyyy').format(d);
  } catch (_) {
    return dateStr;
  }
}
