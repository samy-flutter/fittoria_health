import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/achievements_cubit.dart';
import '../cubit/achievements_state.dart';
import '../../data/models/achievement_models.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AchievementsCubit>()..loadAchievements(),
      child: const _AchievementsView(),
    );
  }
}

class _AchievementsView extends StatelessWidget {
  const _AchievementsView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.fitOrange.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderLg,
              ),
              child: const Icon(LucideIcons.trophy, color: AppColors.fitOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievements',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Your points & rank',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocBuilder<AchievementsCubit, AchievementsState>(
        builder: (context, state) {
          if (state is AchievementsInitial || state is AchievementsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.fitOrange));
          }
          if (state is AchievementsError) {
            return Center(child: Text(state.message, style: GoogleFonts.inter(color: Colors.red)));
          }
          if (state is AchievementsLoaded) {
            final data = state.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroCard(data),
                  const SizedBox(height: 20),
                  if (data.leaderboard.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(LucideIcons.crown, size: 16, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        Text('Leaderboard', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildLeaderboard(data.leaderboard, isDark),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    children: [
                      const Icon(LucideIcons.zap, size: 16, color: AppColors.fitOrange),
                      const SizedBox(width: 8),
                      Text('Recent Points', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (data.ledger.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: [
                            const Icon(LucideIcons.trophy, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text('Start logging workouts & posting to earn points!', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          ],
                        ),
                      ),
                    )
                  else
                    ...data.ledger.map((l) => _buildLedgerEntry(l, isDark)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeroCard(AchievementsData data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2520), Color(0xFF463A2E)],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -60,
            top: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.fitOrange.withValues(alpha: 0.3), Colors.transparent],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CircularProgressIndicator(
                        value: data.intoLevel / 500,
                        strokeWidth: 9,
                        color: AppColors.fitOrange,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('L${data.level}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                          Text('level', style: GoogleFonts.inter(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatNumber(data.total),
                      style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    Text(
                      'total points',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.6)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(LucideIcons.crown, size: 14, color: AppColors.fitOrange),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Rank #${data.rank} · ${data.toNext} pts to level ${data.level + 1}',
                            style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
                          ),
                        ),
                      ],
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

  Widget _buildLeaderboard(List<AchievementUser> leaderboard, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: leaderboard.asMap().entries.map((entry) {
          final i = entry.key;
          final u = entry.value;
          final isLast = i == leaderboard.length - 1;

          final colors = [const Color(0xFFF59E0B), const Color(0xFF9CA3AF), const Color(0xFFB45309)];
          final rankColor = i < 3 ? colors[i] : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted);

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: isLast ? null : Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${i + 1}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: rankColor),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Color(0xFFE8843C), Color(0xFFD26C24)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: u.profilePic != null
                      ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(u.profilePic!, fit: BoxFit.cover))
                      : Center(child: Text(u.fullName[0].toUpperCase(), style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    u.fullName,
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formatNumber(u.points),
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.fitOrange),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLedgerEntry(AchievementLedgerEntry l, bool isDark) {
    IconData iconData = LucideIcons.star;
    String label = l.reason;

    switch (l.reason) {
      case 'workout_logged': iconData = LucideIcons.dumbbell; label = 'Workout logged'; break;
      case 'activity_logged': iconData = LucideIcons.footprints; label = 'Activity logged'; break;
      case 'post_created': iconData = LucideIcons.star; label = 'Shared a post'; break;
      case 'post_liked_received': iconData = LucideIcons.heart; label = 'Post got a like'; break;
      case 'streak_day': iconData = LucideIcons.zap; label = 'Streak day'; break;
      case 'challenge_completed': iconData = LucideIcons.trophy; label = 'Challenge done'; break;
      case 'goal_hit': iconData = LucideIcons.target; label = 'Goal hit'; break;
      case 'event_registered': iconData = LucideIcons.flag; label = 'Event registered'; break;
      case 'event_finished': iconData = LucideIcons.medal; label = 'Event finished'; break;
      case 'onboarding_complete': iconData = LucideIcons.trendingUp; label = 'Profile set up'; break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.fitOrange.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderLg,
            ),
            child: Icon(iconData, color: AppColors.fitOrange, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                // formatting date simply here
                Text(l.createdAt.substring(0, 10), style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              ],
            ),
          ),
          Text(
            '+${l.points}',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF22C55E)),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
