import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../routes/route_names.dart';
import '../../../../injection_container.dart';
import '../../data/models/appointment.dart';
import '../bloc/appointments_bloc.dart';
import '../bloc/appointments_event.dart';
import '../bloc/appointments_state.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppointmentsBloc>(
      create: (_) => sl<AppointmentsBloc>()..add(const LoadAppointments()),
      child: const _AppointmentsBody(),
    );
  }
}

class _AppointmentsBody extends StatelessWidget {
  const _AppointmentsBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'My Appointments',
              style: AppTextStyles.h3.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Manage upcoming and past clinic visits',
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FilledButton.icon(
              onPressed: () => context.push(RouteNames.bookAppointment),
              icon: const Icon(LucideIcons.plus, size: 14),
              label: const Text('New', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AppointmentsBloc, AppointmentsState>(
        listener: (context, state) {
          if (state is AppointmentsError) {
            UIHelpers.showErrorSnackBar(context, state.message);
            // Reload on error after cancel attempt
            context.read<AppointmentsBloc>().add(const LoadAppointments());
          }
        },
        builder: (context, state) {
          if (state is AppointmentsLoading) {
            return _buildSkeletonList();
          } else if (state is AppointmentsLoaded) {
            return _buildLoadedContent(context, state, isDark);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (_, _) => Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(30),
          borderRadius: AppRadius.borderLg,
        ),
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, AppointmentsLoaded state, bool isDark) {
    return Column(
      children: [
        // --- Filter Tabs ---
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
            borderRadius: AppRadius.borderMd,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppointmentFilter.values.map((f) {
                final isActive = f == state.activeFilter;
                final label = _filterLabel(f);
                final count = state.counts[f] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: () => context.read<AppointmentsBloc>().add(ChangeFilter(f)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? (isDark ? AppColors.darkTealLight : AppColors.lightTealLight)
                            : Colors.transparent,
                        borderRadius: AppRadius.borderSm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // --- Appointment List ---
        Expanded(
          child: state.filteredAppointments.isEmpty
              ? _buildEmptyState(context, state.activeFilter, isDark)
              : RefreshIndicator(
                  onRefresh: () async =>
                      context.read<AppointmentsBloc>().add(const LoadAppointments()),
                  color: AppColors.lightTeal,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.filteredAppointments.length,
                    itemBuilder: (context, index) {
                      final appt = state.filteredAppointments[index];
                      final isCancelling = state.cancellingId == appt.id;
                      return _AppointmentCard(
                        appointment: appt,
                        isCancelling: isCancelling,
                        isDark: isDark,
                        onCancel: () => _confirmCancel(context, appt.id),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppointmentFilter filter, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.calendarDays,
              size: 40, color: (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted).withAlpha(128)),
          AppSpacing.heightMd,
          Text(
            'No ${filter != AppointmentFilter.all ? _filterLabel(filter).toLowerCase() : ''} appointments',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.heightMd,
          TextButton.icon(
            onPressed: () => context.push(RouteNames.bookAppointment),
            icon: const Icon(LucideIcons.plus, size: 16),
            label: const Text('Book an appointment'),
            style: TextButton.styleFrom(
              foregroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('No, Keep It'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<AppointmentsBloc>().add(CancelAppointment(appointmentId));
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  String _filterLabel(AppointmentFilter f) {
    switch (f) {
      case AppointmentFilter.all:
        return 'All';
      case AppointmentFilter.upcoming:
        return 'Upcoming';
      case AppointmentFilter.completed:
        return 'Done';
      case AppointmentFilter.cancelled:
        return 'Cancelled';
    }
  }
}

// --- Appointment Card Widget ---
class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isCancelling;
  final bool isDark;
  final VoidCallback onCancel;

  const _AppointmentCard({
    required this.appointment,
    required this.isCancelling,
    required this.isDark,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final canCancel = ['scheduled', 'waiting'].contains(appointment.status);
    final isOnline = appointment.visitType == 'online';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Row ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkTealLight : AppColors.lightTealLight,
                  borderRadius: AppRadius.borderMd,
                ),
                child: Icon(LucideIcons.stethoscope,
                    color: isDark ? AppColors.darkTeal : AppColors.lightTeal, size: 24),
              ),
              AppSpacing.widthMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            appointment.clinicName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusPill(status: appointment.status, isDark: isDark),
                        if (isOnline) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkTealLight : AppColors.lightTealLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? AppColors.darkTealBorder : AppColors.lightTealBorder,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.video,
                                    size: 10,
                                    color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
                                const SizedBox(width: 3),
                                Text(
                                  'Online',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dr. ${appointment.doctorName}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _InfoChip(icon: LucideIcons.calendarDays, text: appointment.appointmentDate),
                        _InfoChip(icon: LucideIcons.clock, text: appointment.slotStart.length >= 5 ? appointment.slotStart.substring(0, 5) : appointment.slotStart),
                        if (appointment.clinicCity != null)
                          _InfoChip(icon: LucideIcons.mapPin, text: appointment.clinicCity!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // --- Complaint ---
          if (appointment.chiefComplaint != null && appointment.chiefComplaint!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted,
                borderRadius: AppRadius.borderSm,
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Complaint: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    TextSpan(
                      text: appointment.chiefComplaint,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],

          // --- Actions Row ---
          const SizedBox(height: 12),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          const SizedBox(height: 12),
          Row(
            children: [
              if (appointment.clinicPhone != null)
                _ActionChip(
                  icon: LucideIcons.phone,
                  label: 'Call',
                  onTap: () {/* url_launcher: tel: */},
                  isDark: isDark,
                ),
              if (isOnline && ['scheduled', 'waiting', 'in_consultation'].contains(appointment.status)) ...[
                const SizedBox(width: 8),
                _ActionChip(
                  icon: LucideIcons.video,
                  label: 'Join',
                  onTap: () {},
                  isDark: isDark,
                  isTeal: true,
                ),
              ],
              const Spacer(),
              if (canCancel)
                isCancelling
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.danger),
                      )
                    : _ActionChip(
                        icon: LucideIcons.xCircle,
                        label: 'Cancel',
                        onTap: onCancel,
                        isDark: isDark,
                        isDanger: true,
                      ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Status Pill ---
class _StatusPill extends StatelessWidget {
  final String status;
  final bool isDark;

  const _StatusPill({required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.$2, width: 1),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colors.$3),
      ),
    );
  }

  (Color bg, Color border, Color text) _statusColors(String s) {
    switch (s) {
      case 'scheduled':
        return (AppColors.cBlueBg, AppColors.cBlueBorder, AppColors.cBlue);
      case 'waiting':
        return (AppColors.lightAmberLight, AppColors.lightAmberBorder, AppColors.warning);
      case 'in_consultation':
        return (AppColors.lightTealLight, AppColors.lightTealBorder, AppColors.lightTeal);
      case 'completed':
        return (AppColors.successBgLight, AppColors.successBorderLight, AppColors.success);
      case 'cancelled':
        return (AppColors.dangerBgLight, AppColors.dangerBorderLight, AppColors.danger);
      case 'no_show':
        return (AppColors.cSlateBg, AppColors.cSlateBorder, AppColors.cSlate);
      default:
        return (AppColors.cSlateBg, AppColors.cSlateBorder, AppColors.cSlate);
    }
  }
}

// --- Info Chip ---
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// --- Action Chip ---
class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isTeal;
  final bool isDanger;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.isTeal = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg, border, fg;
    if (isDanger) {
      bg = AppColors.dangerBgLight;
      border = AppColors.dangerBorderLight;
      fg = AppColors.danger;
    } else if (isTeal) {
      bg = isDark ? AppColors.darkTealLight : AppColors.lightTealLight;
      border = isDark ? AppColors.darkTealBorder : AppColors.lightTealBorder;
      fg = isDark ? AppColors.darkTeal : AppColors.lightTeal;
    } else {
      bg = Colors.transparent;
      border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
      fg = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.borderSm,
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
          ],
        ),
      ),
    );
  }
}
