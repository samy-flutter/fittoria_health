import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/gym_cubit.dart';
import '../../data/models/gym_model.dart';
import '../../../../core/widgets/custom_app_bar.dart';

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
      appBar: const CustomAppBar(title: Text('Gym')),
      body: BlocBuilder<GymCubit, GymState>(
        builder: (context, state) {
          if (state is GymLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.cBlue),
            );
          }

          if (state is GymError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    size: 48,
                    color: AppColors.danger,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load gym data',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
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
              color: AppColors.cBlue,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header matching CRM
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.cBlueBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            LucideIcons.building2,
                            size: 20,
                            color: AppColors.cBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gym',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              'Membership, attendance & classes',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Active Membership Card
                    if (state.data.activeMembership != null)
                      _buildActiveMembershipCard(
                        context,
                        state.data.activeMembership!,
                        isDark,
                      )
                    else
                      _buildEmptyGymCard(isDark),

                    const SizedBox(height: 20),

                    // Stats Row
                    _buildStatsRow(state.data.stats, isDark),

                    // Upcoming Classes
                    if (state.data.upcomingClasses.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildUpcomingClasses(state.data.upcomingClasses, isDark),
                    ],

                    // Attendance History
                    if (state.data.attendance.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildAttendanceHistory(state.data.attendance, isDark),
                    ],

                    // All Memberships
                    if (state.data.memberships.length > 1) ...[
                      const SizedBox(height: 20),
                      _buildAllMemberships(state.data.memberships, isDark),
                    ],

                    if (state.data.activeMembership == null &&
                        state.data.attendance.isEmpty) ...[
                      const SizedBox(height: 20),
                      _buildCompletelyEmptyState(isDark),
                    ],
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

  Widget _buildActiveMembershipCard(
    BuildContext context,
    GymMembership m,
    bool isDark,
  ) {
    int? daysLeft;
    if (m.endDate.isNotEmpty) {
      try {
        final end = DateTime.parse(m.endDate);
        daysLeft = end.difference(DateTime.now()).inDays;
        if (daysLeft < 0) daysLeft = 0;
      } catch (_) {}
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.gymName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (m.planName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "${m.planName}${m.price > 0 ? ' · ₹${m.price.toInt()}' : ''}",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _buildStatusBadge(m.status),
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.calendar,
                    size: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${_formatDate(m.startDate)}${m.endDate.isNotEmpty ? ' — ${_formatDate(m.endDate)}' : ''}",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              if (daysLeft != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: 12,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$daysLeft days left",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          if (m.trainerName.isNotEmpty || m.dietitianName.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (m.trainerName.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBgMuted
                          : AppColors.lightBgMuted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.dumbbell,
                          size: 12,
                          color: AppColors.cBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          m.trainerName,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' · Trainer',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (m.dietitianName.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBgMuted
                          : AppColors.lightBgMuted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          m.dietitianName,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' · Dietitian',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],

          if (m.gymAddress.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    LucideIcons.mapPin,
                    size: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    m.gymAddress,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (m.gymPhone.isNotEmpty) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final url = Uri.parse('tel:${m.gymPhone}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.phone,
                    size: 12,
                    color: AppColors.cBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    m.gymPhone,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.cBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyGymCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.building2,
            size: 32,
            color: isDark
                ? AppColors.darkTextMuted.withValues(alpha: 0.3)
                : AppColors.lightTextMuted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          Text(
            'No active gym membership',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(GymStats? stats, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Visits',
            (stats?.totalVisits ?? 0).toString(),
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'This Month',
            (stats?.thisMonth ?? 0).toString(),
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, bool isDark) {
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
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingClasses(List<GymClassBooking> classes, bool isDark) {
    return _buildListCard(
      title: 'Upcoming Classes',
      isDark: isDark,
      children: classes
          .map(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _parseColor(c.colorHex) ?? AppColors.cBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.className,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${_formatDateTime(c.startAt)}${c.trainerName.isNotEmpty ? ' · ${c.trainerName}' : ''}",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildBookingStatusBadge(c.bookingStatus),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAttendanceHistory(List<GymAttendance> attendance, bool isDark) {
    return _buildListCard(
      title: 'Attendance History',
      isDark: isDark,
      children: attendance
          .map(
            (a) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.successBgLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.checkCircle2,
                      size: 16,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.gymName,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatDateTime(a.checkInAt),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (a.durationMin > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${a.durationMin} min',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'session',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAllMemberships(List<GymMembership> memberships, bool isDark) {
    return _buildListCard(
      title: 'All Memberships',
      isDark: isDark,
      children: memberships
          .map(
            (m) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.gymName,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${m.planName.isNotEmpty ? m.planName : '—'} · ${_formatDate(m.startDate)}",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(m.status),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildListCard({
    required String title,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 12,
            ),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          ...children
              .expand(
                (w) => [
                  w,
                  Divider(
                    height: 1,
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ],
              )
              .toList()
            ..removeLast(),
        ],
      ),
    );
  }

  Widget _buildCompletelyEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.building2,
            size: 40,
            color: isDark
                ? AppColors.darkTextMuted.withValues(alpha: 0.2)
                : AppColors.lightTextMuted.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'No gym data yet',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your gym membership and attendance will appear here once enrolled.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = AppColors.successBgLight;
        textColor = AppColors.success;
        break;
      case 'expired':
      case 'cancelled':
        bgColor = AppColors.dangerBgLight;
        textColor = AppColors.danger;
        break;
      case 'paused':
        bgColor = AppColors.warningBgLight;
        textColor = AppColors.warning;
        break;
      default:
        bgColor = AppColors.cSlateBg;
        textColor = AppColors.cSlate;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildBookingStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'booked':
        bgColor = AppColors.cBlueBg;
        textColor = AppColors.cBlue;
        break;
      case 'checked_in':
        bgColor = AppColors.successBgLight;
        textColor = AppColors.success;
        break;
      case 'waitlist':
        bgColor = AppColors.warningBgLight;
        textColor = AppColors.warning;
        break;
      case 'no_show':
      case 'cancelled':
        bgColor = AppColors.dangerBgLight;
        textColor = AppColors.danger;
        break;
      default:
        bgColor = AppColors.cSlateBg;
        textColor = AppColors.cSlate;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return isoString.split('T').first;
    }
  }

  String _formatDateTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final minuteStr = dt.minute.toString().padLeft(2, '0');
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return "${dt.day}/${dt.month}/${dt.year}, $hour:$minuteStr $ampm";
    } catch (_) {
      return isoString.replaceFirst('T', ' ').substring(0, 16);
    }
  }

  Color? _parseColor(String hexString) {
    if (hexString.isEmpty) return null;
    try {
      final hex = hexString.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return null;
  }
}
