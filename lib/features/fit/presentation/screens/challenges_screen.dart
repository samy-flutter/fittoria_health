import '../../../../core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../data/models/fitness_hub_models.dart';
import '../cubit/challenges_cubit.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChallengesCubit>().loadChallenges();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: const Text('Challenges')),
      body: BlocConsumer<ChallengesCubit, ChallengesState>(
        listener: (context, state) {
          if (state is ChallengesError) {
            UIHelpers.showErrorSnackBar(context, state.message);
          } else if (state is ChallengesActionSuccess) {
            UIHelpers.showSuccessSnackBar(
              context,
              'Joined challenge successfully!',
            );
          }
        },
        builder: (context, state) {
          if (state is ChallengesLoading || state is ChallengesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          List<FitChallengeDetail> activeChallenges = [];
          List<FitChallengeDetail> availableChallenges = [];

          if (state is ChallengesLoaded) {
            activeChallenges = state.challenges.where((c) => c.joined).toList();
            availableChallenges = state.challenges
                .where((c) => !c.joined)
                .toList();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activeChallenges.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.trophy,
                        color: AppColors.fitOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Active Challenges',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...activeChallenges.map(
                    (c) => _ChallengeCard(challenge: c, isActive: true),
                  ),
                  const SizedBox(height: 32),
                ],
                if (availableChallenges.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.sparkles,
                        color: AppColors.fitOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Available to Join',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...availableChallenges.map(
                    (c) => _ChallengeCard(challenge: c, isActive: false),
                  ),
                ],
                if (activeChallenges.isEmpty && availableChallenges.isEmpty)
                  Center(
                    child: Text(
                      'No challenges available.',
                      style: GoogleFonts.inter(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final FitChallengeDetail challenge;
  final bool isActive;

  const _ChallengeCard({required this.challenge, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentValue = challenge.currentValue ?? 0;
    final pct = challenge.targetValue > 0
        ? (currentValue / challenge.targetValue * 100).toInt()
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                challenge.title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (isActive)
                Text(
                  '$pct%',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.fitOrange,
                  ),
                )
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.fitOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () {
                    context.read<ChallengesCubit>().joinChallenge(challenge.id);
                  },
                  child: const Text('Join'),
                ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 8),
            Text(
              '${(challenge.currentValue ?? 0).toInt()} / ${challenge.targetValue.toInt()} ${challenge.unit} completed',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (pct / 100).clamp(0.0, 1.0),
                color: AppColors.fitOrange,
                backgroundColor: AppColors.fitOrange.withValues(alpha: 0.15),
                minHeight: 8,
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'Goal: ${challenge.targetValue.toInt()} ${challenge.unit}',
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
    );
  }
}
