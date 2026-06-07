import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/gym_cubit.dart';
import '../../data/models/gym_model.dart';

class GymDetailsScreen extends StatelessWidget {
  const GymDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GymCubit>()..loadGymData(),
      child: const _GymDetailsScreenView(),
    );
  }
}

class _GymDetailsScreenView extends StatelessWidget {
  const _GymDetailsScreenView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('My Gym'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<GymCubit, GymState>(
        builder: (context, state) {
          if (state is GymLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.fitOrange),
            );
          }

          if (state is GymError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.alertCircle, size: 48, color: AppColors.danger),
                  const SizedBox(height: 16),
                  Text('Failed to load gym data', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(state.message, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<GymCubit>().loadGymData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is GymLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<GymCubit>().loadGymData(),
              color: AppColors.fitOrange,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildGymHeader(context, state.data.activeMembership, isDark),
                    const SizedBox(height: 32),
                    _buildQrCard(context, isDark),
                    const SizedBox(height: 32),
                    if (state.data.activeMembership != null) ...[
                      _buildDetailRow('Status', state.data.activeMembership!.status.toUpperCase(), isDark),
                      _buildDetailRow('Valid Until', state.data.activeMembership!.endDate.split('T').first, isDark),
                      _buildDetailRow('Plan', state.data.activeMembership!.planName, isDark),
                    ],
                    const SizedBox(height: 32),
                    _buildStatsRow(state.data.stats, isDark),
                    if (state.data.upcomingClasses.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Upcoming Classes', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 16),
                      ...state.data.upcomingClasses.map((c) => _buildClassCard(c, isDark)),
                    ]
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGymHeader(BuildContext context, GymMembership? membership, bool isDark) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFFB7C37).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.building2, size: 48, color: Color(0xFFFB7C37)),
        ),
        const SizedBox(height: 16),
        Text(
          membership?.gymName ?? 'No Active Gym',
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          membership?.planName ?? 'Select a membership plan to continue',
          style: GoogleFonts.inter(fontSize: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        ),
      ],
    );
  }

  Widget _buildQrCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          const Icon(LucideIcons.qrCode, size: 150),
          const SizedBox(height: 16),
          Text(
            'Scan at Reception',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatsRow(GymStats? stats, bool isDark) {
    if (stats == null) return const SizedBox.shrink();
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Total Visits', stats.totalVisits.toString(), LucideIcons.calendarCheck, isDark),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard('This Month', stats.thisMonth.toString(), LucideIcons.barChart2, isDark),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.fitOrange, size: 24),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
        ],
      ),
    );
  }

  Widget _buildClassCard(GymClassBooking booking, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.fitOrange.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderLg,
            ),
            child: const Icon(LucideIcons.users, color: AppColors.fitOrange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.className, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  '${booking.startAt.split('T').last.substring(0, 5)} - ${booking.endAt.split('T').last.substring(0, 5)}',
                  style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
              borderRadius: AppRadius.borderMd,
            ),
            child: Text(
              booking.bookingStatus.toUpperCase(),
              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.fitOrange),
            ),
          ),
        ],
      ),
    );
  }
}
