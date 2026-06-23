import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../../../../routes/route_names.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/dashboard_skeleton.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../appointments/data/models/appointment.dart';
import '../../../profile_records/data/models/profile_models.dart';
import '../../../fit/data/models/fitness_models.dart';

extension NavigationExtension on BuildContext {
  void navigateTo(String route) {
    push(route);
  }
}

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
            return const DashboardSkeleton();
          }
          if (state is DashboardError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<DashboardCubit>().loadDashboardData(),
            );
          }
          if (state is DashboardLoaded) {
            return _DashboardContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardLoaded state;
  const _DashboardContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.fitOrange,
      onRefresh: () => context.read<DashboardCubit>().loadDashboardData(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _GreetingHeader(
                  profile: state.profile,
                  onboardingStatus: state.onboardingStatus,
                ),
                const SizedBox(height: 20),

                _OnboardingPrompt(completed: state.onboardingStatus.completed),
                const SizedBox(height: 20),

                _ActivityHero(
                  today: state.fitnessSummary.today,
                  goals: state.fitnessSummary.goals,
                ),
                const SizedBox(height: 20),

                _WeeklyStepsChart(weekSteps: state.fitnessSummary.weekSteps),
                const SizedBox(height: 20),

                _CareTeamList(
                  careTeam: state.fitnessSummary.careTeam,
                  nextAppt: state.nextAppointment,
                ),
                const SizedBox(height: 20),

                _GoalsList(goals: state.fitnessSummary.goals),
                const SizedBox(height: 20),

                _MetricsGrid(
                  vitals: state.fitnessSummary.vitals,
                  today: state.fitnessSummary.today,
                ),
                const SizedBox(height: 20),

                if (state.fitnessSummary.academyVideos.isNotEmpty) ...[
                  _AcademyVideos(videos: state.fitnessSummary.academyVideos),
                  const SizedBox(height: 20),
                ],

                if (state.fitnessSummary.challenges.isNotEmpty) ...[
                  _ChallengesList(challenges: state.fitnessSummary.challenges),
                  const SizedBox(height: 20),
                ],

                const _DiscoverGrid(),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Greeting Header ────────────────────────────────────────────────────────

class _GreetingHeader extends StatelessWidget {
  final PatientProfile profile;
  final OnboardingStatus onboardingStatus;

  const _GreetingHeader({
    required this.profile,
    required this.onboardingStatus,
  });

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }

  String get _firstName => profile.fullName.split(' ').first;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initial = _firstName.isNotEmpty ? _firstName[0].toUpperCase() : 'P';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFE8843C), Color(0xFFD26C24)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good $_greeting,',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                Text(
                  '$_firstName 👋',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2520),
                borderRadius: AppRadius.borderXl,
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.trophy,
                    size: 16,
                    color: AppColors.fitOrange,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    NumberFormat.decimalPattern().format(
                      onboardingStatus.points,
                    ),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.navigateTo(RouteNames.patientFitLog),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.fitOrange,
                  borderRadius: AppRadius.borderXl,
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Log',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Onboarding Prompt ──────────────────────────────────────────────────────

class _OnboardingPrompt extends StatelessWidget {
  final bool completed;

  const _OnboardingPrompt({this.completed = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.navigateTo(RouteNames.patientOnboarding),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2A2520), Color(0xFF463A2E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.borderXl,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.fitOrange.withValues(alpha: 0.2),
                borderRadius: AppRadius.borderLg,
              ),
              child: const Icon(
                LucideIcons.activity,
                color: AppColors.fitOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    completed
                        ? 'Update personalization'
                        : 'Personalize your experience',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    completed
                        ? 'Adjust your health goals and path'
                        : 'Set your goals & path · earn 25 points',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.arrowRight,
              color: Colors.white.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Activity Hero ──────────────────────────────────────────────────────────

class _ActivityHero extends StatelessWidget {
  final FitToday today;
  final List<FitGoal> goals;
  const _ActivityHero({required this.today, required this.goals});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Find step goal or default to 10000
    double targetSteps = 10000;
    try {
      targetSteps = goals.firstWhere((g) => g.goalType == 'steps').targetValue;
      if (targetSteps == 0) targetSteps = 10000;
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFBE8D6), Color(0xFFF5DCC4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.borderXl,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TODAY'S ACTIVITY",
                style: GoogleFonts.inter(
                  color: const Color(0xFFB05A1E),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () => context.navigateTo(RouteNames.patientFitActivity),
                child: Row(
                  children: [
                    Text(
                      'Details',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFB05A1E),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      LucideIcons.chevronRight,
                      color: Color(0xFFB05A1E),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Progress Ring (simulated with a Container for now)
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.fitOrange, width: 9),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(today.steps / 1000).toStringAsFixed(1)}k',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF2A2520),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'steps',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8A6A4A),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ActivityStat(
                      icon: LucideIcons.mapPin,
                      label: 'Distance',
                      value: today.distanceKm.toStringAsFixed(1),
                      unit: 'km',
                    ),
                    _ActivityStat(
                      icon: LucideIcons.flame,
                      label: 'Calories',
                      value: today.caloriesKcal.toString(),
                      unit: 'kcal',
                    ),
                    _ActivityStat(
                      icon: LucideIcons.clock,
                      label: 'Active',
                      value: today.activeMinutes.toString(),
                      unit: 'min',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const _ActivityStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFB05A1E), size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFFB05A1E),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: const Color(0xFF2A2520),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: GoogleFonts.inter(
                color: const Color(0xFF2A2520),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Weekly Steps Chart ─────────────────────────────────────────────────────

class _WeeklyStepsChart extends StatelessWidget {
  final List<FitWeekStep> weekSteps;
  const _WeeklyStepsChart({required this.weekSteps});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.footprints,
                    color: AppColors.fitOrange,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Steps This Week',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.navigateTo(RouteNames.patientFitActivity),
                child: Row(
                  children: [
                    Text(
                      'View all',
                      style: GoogleFonts.inter(
                        color: AppColors.fitOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      LucideIcons.chevronRight,
                      color: AppColors.fitOrange,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (weekSteps.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No activity yet.',
                style: GoogleFonts.inter(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                  fontSize: 12,
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weekSteps.map((step) {
                // Approximate max steps for chart height
                final double heightPct = (step.steps / 10000).clamp(0.0, 1.0);
                final dayLabel = step.date
                    .split('-')
                    .last; // simplified day label

                return Column(
                  children: [
                    Container(
                      width: 24,
                      height: 100 * heightPct + 4, // Min height
                      decoration: BoxDecoration(
                        color: AppColors.fitOrange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dayLabel,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

// ─── Care Team List ─────────────────────────────────────────────────────────

class _CareTeamList extends StatelessWidget {
  final FitCareTeam careTeam;
  final Appointment? nextAppt;

  const _CareTeamList({required this.careTeam, this.nextAppt});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.users,
                  color: AppColors.fitOrange,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'My Care Team',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => context.navigateTo(RouteNames.patientCare),
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.fitOrange,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Gym
        GestureDetector(
          onTap: () => context.navigateTo(RouteNames.patientGym),
          child: _CareTeamCard(
            icon: LucideIcons.building2,
            iconColor: const Color(0xFFFB7C37),
            title: careTeam.gym?.gymName ?? 'Gym',
            subtitle: careTeam.gym?.planName ?? 'No active membership',
            showTrailing: true,
          ),
        ),
        const SizedBox(height: 12),

        // Trainer & Dietitian Split
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context.navigateTo(RouteNames.patientFitness),
                child: _CareTeamCard(
                  icon: LucideIcons.dumbbell,
                  iconColor: const Color(0xFF22C55E),
                  title: careTeam.trainer?.trainerName ?? 'Trainer',
                  subtitle: careTeam.trainer?.specialization ?? 'Not assigned',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => context.navigateTo(RouteNames.patientNutrition),
                child: _CareTeamCard(
                  icon: LucideIcons.salad,
                  iconColor: const Color(0xFFA78BFA),
                  title: careTeam.dietitian?.dietitianName ?? 'Dietitian',
                  subtitle:
                      careTeam.dietitian?.specialization ?? 'Not assigned',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Video Consultations (Meetings)
        GestureDetector(
          onTap: () => context.navigateTo(RouteNames.patientMeetings),
          child: _CareTeamCard(
            icon: LucideIcons.video,
            iconColor: const Color(0xFFF472B6),
            title: careTeam.nextMeeting?.title ?? 'Video Consultations',
            subtitle:
                careTeam.nextMeeting?.staffName ??
                'View past & upcoming meetings',
            overline: careTeam.nextMeeting != null ? 'NEXT MEETING' : null,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _CareTeamCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? overline;
  final bool showTrailing;

  const _CareTeamCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.overline,
    this.showTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: AppRadius.borderLg,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (overline != null)
                  Text(
                    overline!,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                if (overline != null) const SizedBox(height: 2),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showTrailing)
            Icon(
              LucideIcons.chevronRight,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
              size: 16,
            ),
        ],
      ),
    );
  }
}

// ─── Goals List ─────────────────────────────────────────────────────────────

class _GoalsList extends StatelessWidget {
  final List<FitGoal> goals;
  const _GoalsList({required this.goals});

  IconData _getGoalIcon(String type) {
    switch (type) {
      case 'steps':
        return LucideIcons.footprints;
      case 'calories_burn':
        return LucideIcons.flame;
      case 'calories_intake':
        return LucideIcons.apple;
      case 'active_minutes':
        return LucideIcons.clock;
      case 'water_ml':
        return LucideIcons.droplets;
      case 'sleep_min':
        return LucideIcons.moon;
      case 'workouts_week':
        return LucideIcons.dumbbell;
      case 'weight_kg':
        return LucideIcons.scale;
      default:
        return LucideIcons.activity;
    }
  }

  String _getGoalLabel(String type) {
    switch (type) {
      case 'steps':
        return 'Steps';
      case 'calories_burn':
        return 'Calories Burn';
      case 'calories_intake':
        return 'Calorie Intake';
      case 'active_minutes':
        return 'Active Minutes';
      case 'water_ml':
        return 'Water';
      case 'sleep_min':
        return 'Sleep';
      case 'workouts_week':
        return 'Workouts';
      case 'weight_kg':
        return 'Weight';
      default:
        return type.replaceAll('_', ' ');
    }
  }

  String _getGoalUnit(String type) {
    switch (type) {
      case 'steps':
        return '';
      case 'calories_burn':
        return 'kcal';
      case 'calories_intake':
        return 'kcal';
      case 'active_minutes':
        return 'min';
      case 'water_ml':
        return 'ml';
      case 'sleep_min':
        return 'min';
      case 'workouts_week':
        return '';
      case 'weight_kg':
        return 'kg';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context.navigateTo(RouteNames.patientFitGoals),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.trendingUp,
                    color: AppColors.fitOrange,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'All Goals',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => context.navigateTo(RouteNames.patientFitGoals),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.plus,
                    color: AppColors.fitOrange,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Add goal',
                    style: GoogleFonts.inter(
                      color: AppColors.fitOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (goals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: AppRadius.borderXl,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  LucideIcons.plus,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  'Set your first goal',
                  style: GoogleFonts.inter(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: goals
                .map(
                  (g) => _GoalCard(
                    icon: _getGoalIcon(g.goalType),
                    label: _getGoalLabel(g.goalType),
                    unit: _getGoalUnit(g.goalType),
                    current: g.current,
                    target: g.targetValue,
                    pct: g.pct,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String unit;
  final double current;
  final double target;
  final int pct;

  const _GoalCard({
    required this.icon,
    required this.label,
    required this.unit,
    required this.current,
    required this.target,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayCur = current.toInt().toString();
    final displayTgt = target.toInt().toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.fitOrange.withValues(alpha: 0.15),
              borderRadius: AppRadius.borderLg,
            ),
            child: Icon(icon, color: AppColors.fitOrange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      '$displayCur / $displayTgt $unit',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (pct / 100).clamp(0.0, 1.0),
                    backgroundColor: isDark
                        ? AppColors.darkBgBase
                        : AppColors.lightBgBase,
                    color: AppColors.fitOrange,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Progress Ring label
          Text(
            '$pct%',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.fitOrange,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Metrics Grid ───────────────────────────────────────────────────────────

class _MetricsGrid extends StatelessWidget {
  final FitVitals vitals;
  final FitToday today;
  const _MetricsGrid({required this.vitals, required this.today});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _MetricCard(
          icon: LucideIcons.heartPulse,
          accent: const Color(0xFFEF4444),
          value: vitals.heartRateBpm?.toString() ?? '—',
          unit: 'bpm',
          label: 'Heart Rate',
        ),
        _MetricCard(
          icon: LucideIcons.moon,
          accent: const Color(0xFF8B5CF6),
          value: vitals.sleepTotalMin != null
              ? '${vitals.sleepTotalMin! ~/ 60}h ${vitals.sleepTotalMin! % 60}m'
              : '—',
          unit: '',
          label: 'Last Sleep',
        ),
        _MetricCard(
          icon: LucideIcons.droplets,
          accent: const Color(0xFF3B82F6),
          value: (today.waterMl / 1000).toStringAsFixed(1),
          unit: 'L',
          label: 'Water Today',
        ),
        _MetricCard(
          icon: LucideIcons.apple,
          accent: const Color(0xFF22C55E),
          value: today.nutritionKcal.toString(),
          unit: 'kcal',
          label: 'Eaten Today',
        ),
        _MetricCard(
          icon: LucideIcons.smile,
          accent: const Color(0xFFF59E0B),
          value: vitals.mood ?? '—',
          unit: '',
          label: 'Mood',
        ),
        _MetricCard(
          icon: LucideIcons.dumbbell,
          accent: AppColors.fitOrange,
          value: vitals.workoutsThisWeek.toString(),
          unit: '',
          label: 'Workouts / wk',
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String value;
  final String unit;
  final String label;

  const _MetricCard({
    required this.icon,
    required this.accent,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
          Row(
            children: [
              Icon(icon, size: 16, color: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Academy Videos ─────────────────────────────────────────────────────────

class _AcademyVideos extends StatelessWidget {
  final List<AcademyVideo> videos;
  const _AcademyVideos({required this.videos});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.graduationCap,
                  color: Color(0xFF8B5CF6),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Fittoria Academy',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => context.navigateTo(RouteNames.patientAcademy),
              child: Row(
                children: [
                  Text(
                    'View all',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8B5CF6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    LucideIcons.chevronRight,
                    color: Color(0xFF8B5CF6),
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: videos
              .map(
                (v) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBgSurface
                        : AppColors.lightBgSurface,
                    borderRadius: AppRadius.borderXl,
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkBgBase
                              : AppColors.lightBgBase,
                          borderRadius: AppRadius.borderLg,
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.play,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${v.category} · ${v.durationSec ~/ 60}m ${v.durationSec % 60}s · ${v.viewCount} views',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ─── Challenges List ────────────────────────────────────────────────────────

class _ChallengesList extends StatelessWidget {
  final List<FitChallenge> challenges;
  const _ChallengesList({required this.challenges});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.trophy,
                  color: AppColors.fitOrange,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Active Challenges',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => context.navigateTo(RouteNames.patientChallenges),
              child: Row(
                children: [
                  Text(
                    'View all',
                    style: GoogleFonts.inter(
                      color: AppColors.fitOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    LucideIcons.chevronRight,
                    color: AppColors.fitOrange,
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: challenges.map((c) {
            final pct = c.targetValue > 0
                ? (c.currentValue / c.targetValue * 100).toInt()
                : 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBgSurface
                    : AppColors.lightBgSurface,
                borderRadius: AppRadius.borderXl,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        c.title,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        '$pct%',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.fitOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (pct / 100).clamp(0.0, 1.0),
                      backgroundColor: isDark
                          ? AppColors.darkBgBase
                          : AppColors.lightBgBase,
                      color: AppColors.fitOrange,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Discover Grid ──────────────────────────────────────────────────────────

class _DiscoverGrid extends StatelessWidget {
  const _DiscoverGrid();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      {
        'label': 'Community',
        'icon': LucideIcons.users,
        'route': '/patient/social',
        'color': const Color(0xFF3B82F6),
      },
      {
        'label': 'Events',
        'icon': LucideIcons.flag,
        'route': '/patient/events',
        'color': const Color(0xFFEF4444),
      },
      {
        'label': 'Trainers',
        'icon': LucideIcons.dumbbell,
        'route': '/patient/trainers',
        'color': const Color(0xFF22C55E),
      },
      {
        'label': 'AI Food',
        'icon': LucideIcons.sparkles,
        'route': '/patient/ai-nutrition',
        'color': AppColors.fitOrange,
      },
      {
        'label': 'Rewards',
        'icon': LucideIcons.trophy,
        'route': '/patient/achievements',
        'color': const Color(0xFFF59E0B),
      },
      {
        'label': 'Lab Test',
        'icon': LucideIcons.flaskConical,
        'route': '/patient/lab-booking',
        'color': const Color(0xFF00D4B4),
      },
      {
        'label': 'Shop',
        'icon': LucideIcons.shoppingBag,
        'route': '/patient/shop',
        'color': const Color(0xFFEC4899),
      },
      {
        'label': 'Academy',
        'icon': LucideIcons.graduationCap,
        'route': '/patient/academy',
        'color': const Color(0xFF8B5CF6),
      },
    ];

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.sparkles,
              color: AppColors.fitOrange,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Discover',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final color = item['color'] as Color;
            return GestureDetector(
              onTap: () => context.navigateTo(item['route'] as String),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBgSurface
                      : AppColors.lightBgSurface,
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        size: 18,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['label'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
