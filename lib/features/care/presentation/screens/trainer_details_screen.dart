import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/fitness_details_cubit.dart';
import '../../data/models/fitness_details_model.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class TrainerDetailsScreen extends StatelessWidget {
  const TrainerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FitnessDetailsCubit>()..loadFitnessDetails(),
      child: const _TrainerDetailsScreenView(),
    );
  }
}

class _TrainerDetailsScreenView extends StatelessWidget {
  const _TrainerDetailsScreenView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('My Trainer'),
        ),
      body: BlocBuilder<FitnessDetailsCubit, FitnessDetailsState>(
        builder: (context, state) {
          if (state is FitnessDetailsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.fitOrange));
          }

          if (state is FitnessDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.alertCircle, size: 48, color: AppColors.danger),
                  const SizedBox(height: 16),
                  Text('Failed to load trainer details', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(state.message, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<FitnessDetailsCubit>().loadFitnessDetails(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FitnessDetailsLoaded) {
            final isEmpty = state.data.trainer == null && state.data.activePlan == null && state.data.tracking.isEmpty;

            Widget content = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTrainerHeader(context, state.data.trainer, isDark),
                const SizedBox(height: 32),
                if (state.data.trainer != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(LucideIcons.messageCircle, 'Message', isDark),
                      const SizedBox(width: 16),
                      _buildActionButton(LucideIcons.video, 'Meeting', isDark),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
                _buildActivePlan(state.data.activePlan, isDark),
                const SizedBox(height: 32),
                if (state.data.tracking.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Recent Tracking', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  ...state.data.tracking.map((t) => _buildTrackingCard(t, isDark)),
                ]
              ],
            );

            return RefreshIndicator(
              onRefresh: () => context.read<FitnessDetailsCubit>().loadFitnessDetails(),
              color: AppColors.fitOrange,
              child: isEmpty
                  ? CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildTrainerHeader(context, state.data.trainer, isDark),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: content,
                    ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTrainerHeader(BuildContext context, FitnessTrainer? trainer, bool isDark) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFFB7C37).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.user, size: 48, color: Color(0xFFFB7C37)),
        ),
        const SizedBox(height: 16),
        Text(
          trainer?.trainerName ?? 'No Active Trainer',
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          trainer?.specialization ?? 'Get matched with a professional',
          style: GoogleFonts.inter(fontSize: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.fitOrange),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActivePlan(FitnessPlan? plan, bool isDark) {
    if (plan == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Active Plan', style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 8),
          Text(plan.title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(plan.description, style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          const SizedBox(height: 16),
          if (plan.exercises.isNotEmpty) ...[
            Text('Exercises', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...plan.exercises.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(LucideIcons.checkCircle2, size: 16, color: AppColors.fitOrange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('${e.exerciseName} (${e.sets}x${e.reps})', style: GoogleFonts.inter(fontSize: 14)),
                  ),
                ],
              ),
            )),
          ]
        ],
      ),
    );
  }

  Widget _buildTrackingCard(WorkoutTracking tracking, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tracking.exerciseName, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(tracking.trackingDate.split('T').first, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: tracking.compliance > 80 ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderMd,
            ),
            child: Text(
              '${tracking.compliance}%',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: tracking.compliance > 80 ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
