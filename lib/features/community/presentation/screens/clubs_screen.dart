import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/clubs_cubit.dart';
import '../cubit/clubs_state.dart';
import '../../data/models/club_models.dart';

class ClubsScreen extends StatelessWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClubsCubit>()..loadClubs(),
      child: const _ClubsView(),
    );
  }
}

class _ClubsView extends StatelessWidget {
  const _ClubsView();

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
              child: const Icon(LucideIcons.messageCircle, color: AppColors.fitOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clubs',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Find your tribe',
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
      body: BlocBuilder<ClubsCubit, ClubsState>(
        builder: (context, state) {
          if (state is ClubsLoading || state is ClubsInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.fitOrange));
          }
          if (state is ClubsError) {
            return Center(child: Text(state.message, style: GoogleFonts.inter(color: Colors.red)));
          }
          if (state is ClubsLoaded) {
            if (state.clubs.isEmpty) {
              return Center(
                child: Text(
                  'No clubs available.',
                  style: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              );
            }
            return RefreshIndicator(
              color: AppColors.fitOrange,
              onRefresh: () => context.read<ClubsCubit>().loadClubs(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.clubs.length,
                itemBuilder: (context, index) {
                  return _ClubCard(club: state.clubs[index]);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  final SocialClub club;

  const _ClubCard({required this.club});

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coverColor = _parseColor(club.coverColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [coverColor, coverColor.withValues(alpha: 0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      club.category,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        club.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(LucideIcons.users, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        const SizedBox(width: 4),
                        Text(
                          '${club.memberCount}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  club.description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 16),
                if (club.joined)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.fitOrange,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            // Navigate to chat
                            context.push('/patient/clubs/${club.id}/chat?name=${Uri.encodeComponent(club.name)}');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(LucideIcons.messageCircle, size: 18),
                              const SizedBox(width: 8),
                              Text('Go to Chat', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        onPressed: () => context.read<ClubsCubit>().toggleMembership(club.id),
                        child: const Icon(LucideIcons.logOut, size: 18),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fitOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => context.read<ClubsCubit>().toggleMembership(club.id),
                      child: Text('Join Club', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
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
